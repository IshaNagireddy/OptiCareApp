//
//  SlitLampView.swift
//  OptiCare
//
//  Created by Isha Nagireddy on 1/14/24.
//

import UIKit

class SlitLampView: UIViewController, UIImagePickerControllerDelegate & UINavigationControllerDelegate {

    @IBOutlet weak var analyzeButton: UIButton!
    @IBOutlet weak var satisfiedLabel: UILabel!
    @IBOutlet weak var eyeImage: UIImageView!
    @IBOutlet weak var takePictureButton: UIButton!
    @IBOutlet weak var testLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    
    static var finalImage = UIImage()
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    @IBAction func pictureButtonClicked(_ sender: Any) {
        let picker = UIImagePickerController()
        picker.allowsEditing = true
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            picker.sourceType = .photoLibrary
            print("camera should work")
        }
        
        else{
            print("camera not avaiable")
        }
        
        picker.delegate = self
        present(picker, animated:true)
        
    }
    @IBAction func analyzeButtonClicked(_ sender: Any) {
        SlitLampView.finalImage = eyeImage.image!
    }
    
}

extension SlitLampView {
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true, completion: nil)
        guard let image = info[UIImagePickerController.InfoKey.originalImage] as?
                UIImage else {
            return
        }
        
        eyeImage.image = image
        
    }
}
