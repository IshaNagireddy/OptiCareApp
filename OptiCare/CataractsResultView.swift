//
//  CataractsResultView.swift
//  OptiCare
//
//  Created by Isha Nagireddy on 1/14/24.
//

import UIKit
import FirebaseMLModelDownloader
import TensorFlowLite

class CataractsResultView: UIViewController {
    
    @IBOutlet weak var nextStepsButton: UIButton!
    @IBOutlet weak var percentageLabel: UILabel!
    @IBOutlet weak var resultsLabel: UILabel!
    @IBOutlet weak var resultsDescriptionLabel: UILabel!
    
    static var slitLamp = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        percentageLabel.text = "...."
        
        let inputWidth = 256
        let inputHeight = 128
        
        let conditions = ModelDownloadConditions(allowsCellularAccess: true)
        ModelDownloader.modelDownloader()
            .getModel(name: "cataracts",
                      downloadType: .latestModel,
                      conditions: conditions) { result in
                switch (result) {
                case .success(let customModel):
                    do {

                        let interpreter = try Interpreter(modelPath: customModel.path)
                        let resizedImage = self.resizeImage(image: SlitLampView.finalImage, targetSize: CGSize(width: 256, height: 128))
                        let image: CGImage = resizedImage.cgImage!
                        
                        guard let context = CGContext(
                          data: nil,
                          width: image.width, height: image.height,
                          bitsPerComponent: 8, bytesPerRow: image.width * 4,
                          space: CGColorSpaceCreateDeviceRGB(),
                          bitmapInfo: CGImageAlphaInfo.noneSkipFirst.rawValue
                        ) else {
                          return
                        }

                        context.draw(image, in: CGRect(x: 0, y: 0, width: image.width, height: image.height))
                        guard let imageData = context.data else { return }
                        var inputData = Data()
                        for row in 0..<inputHeight {
                            for col in 0..<inputWidth {
                                let offset = 4 * (row * context.width + col)
                                    // (Ignore offset 0, the unused alpha channel)
                                    let red = imageData.load(fromByteOffset: offset+1, as: UInt8.self)
                                    let green = imageData.load(fromByteOffset: offset+2, as: UInt8.self)
                                    let blue = imageData.load(fromByteOffset: offset+3, as: UInt8.self)

                                    // Normalize channel values to [0.0, 1.0]. This requirement varies
                                    // by model. For example, some models might require values to be
                                    // normalized to the range [-1.0, 1.0] instead, and others might
                                    // require fixed-point values or the original bytes.
                                    var normalizedRed = Float32(red) / 255.0
                                    var normalizedGreen = Float32(green) / 255.0
                                    var normalizedBlue = Float32(blue) / 255.0
                                
                                    print("red", normalizedRed)
                                    print("green", normalizedGreen)
                                    print("blue", normalizedBlue)

                                    // Append normalized values to Data object in RGB order.
                                    let elementSize = MemoryLayout.size(ofValue: normalizedRed)
                                    var bytes = [UInt8](repeating: 0, count: elementSize)
                                    memcpy(&bytes, &normalizedRed, elementSize)
                                    inputData.append(&bytes, count: elementSize)
                                    memcpy(&bytes, &normalizedGreen, elementSize)
                                    inputData.append(&bytes, count: elementSize)
                                    memcpy(&bytes, &normalizedBlue, elementSize)
                                    inputData.append(&bytes, count: elementSize)
                            }
                        }
                        
                        try interpreter.allocateTensors()
                        try interpreter.copy(inputData, toInputAt: 0)
                        try interpreter.invoke()
                        
                        print("it worked!")
                        
                        let output = try interpreter.output(at: 0)
                        let probabilities =
                                UnsafeMutableBufferPointer<Float32>.allocate(capacity: 1000)
                        output.data.copyBytes(to: probabilities)

                        guard let labelPath = Bundle.main.path(forResource: "labels", ofType: "txt") else { return }
                        let fileContents = try? String(contentsOfFile: labelPath)
                        guard let labels = fileContents?.components(separatedBy: "\n") else { return }

                        for i in labels.indices {
                            print("\(labels[i]): \(probabilities[i])")
                        }
                        
                        if (probabilities[0] < 0.001) {
                            self.percentageLabel.text = "0%"
                        }
                        
                        else {
                            self.percentageLabel.text = String(format: "%.0f", probabilities[0]*100) + "%"
                        }
                        
                        self.resultsLabel.text = "that you have cataracts"
                        
                        // what if the string has e in it? check case
                        if (probabilities[0] >= 0.5) {
                            self.resultsDescriptionLabel.text = "You are suspected to have cataracts. Please tae the questionaire to determine your specific level of risk."
                            self.nextStepsButton.setTitle("Take the severity questionaire", for: .normal)
                            CataractsResultView.slitLamp = true
                        }
                        
                        else {
                            self.resultsDescriptionLabel.text = "You are not suspected to have cataracts. Thank you for testing, no futher action needs to be taken!"
                            self.nextStepsButton.setTitle("Return home", for: .normal)
                            CataractsResultView.slitLamp = false
                        }
                        
                    } catch {
                        print("Failed to create the interpreter with error: \(error.localizedDescription)")
                        return
                    }
                case .failure(let error):
                    // Download was unsuccessful. Don't enable ML features.
                    print(error.localizedDescription)
                }
        }
        
    }
        
    
        @IBAction func nextStepsButtonClicked(_ sender: Any) {
            if (CataractsResultView.slitLamp == true) {
                performSegue(withIdentifier: "toSeverityFromCataracts", sender: nil)
            }
            
            else {
                if (ChooseDiseaseView.rightEye == false) {
                    performSegue(withIdentifier: "toHomePageFromCataracts", sender: nil)
                }
                
                else {
                    ChooseDiseaseView.rightEye = false
                    performSegue(withIdentifier: "toTestingAgainCataracts", sender: nil)
                }
            }
            
        }
        
        func resizeImage(image: UIImage, targetSize: CGSize) -> UIImage {
            let size = image.size
            
            let widthRatio  = targetSize.width  / size.width
            let heightRatio = targetSize.height / size.height
            
            // Figure out what our orientation is, and use that to form the rectangle
            var newSize: CGSize
            if(widthRatio > heightRatio) {
                newSize = CGSize(width: size.width * heightRatio, height: size.height * heightRatio)
            } else {
                newSize = CGSize(width: size.width * widthRatio,  height: size.height * widthRatio)
            }
            
            // This is the rect that we've calculated out and this is what is actually used below
            let rect = CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height)
            
            // Actually do the resizing to the rect using the ImageContext stuff
            UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
            image.draw(in: rect)
            let newImage = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            return newImage!
        }
    
}
