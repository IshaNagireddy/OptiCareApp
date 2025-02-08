//
//  FundusImagesView.swift
//  OptiCare
//
//  Created by Isha Nagireddy on 1/14/24.
//

import UIKit

class FundusImagesView: UIViewController, UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var satisfiedLabel: UILabel!
    @IBOutlet weak var noFundusLabel: UILabel!
    @IBOutlet weak var analyzeButton: UIButton!
    @IBOutlet weak var fundusImage: UIImageView!
    @IBOutlet weak var takePictureButton: UIButton!
    @IBOutlet weak var testLabel: UILabel!
    
    static var finalGlaucomaImage = UIImage()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    @IBAction func pictureButtonClicked(_ sender: Any) {
        let picker = UIImagePickerController()
        picker.allowsEditing = true
        picker.sourceType = .photoLibrary
        picker.delegate = self
        present(picker, animated:true)
    }
    @IBAction func analyzeButtonClicked(_ sender: Any) {
        FundusImagesView.finalGlaucomaImage = fundusImage.image!
    }
}

extension FundusImagesView {
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true, completion: nil)
        guard let image = info[UIImagePickerController.InfoKey.originalImage] as?
                UIImage else {
            return
        }
        
        fundusImage.image = image
        
    }
}
