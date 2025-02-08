//
//  ChooseDiseaseView.swift
//  OptiCare
//
//  Created by Isha Nagireddy on 1/14/24.
//

import UIKit

class ChooseDiseaseView: UIViewController {
    
    @IBOutlet weak var whichDiseaseLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var glaucomaButton: UIButton!
    @IBOutlet weak var cataractsButton: UIButton!
    @IBOutlet weak var resourcesButton: UIButton!
    @IBOutlet weak var cataractsImage: UIImageView!
    @IBOutlet weak var resourcesLabel: UILabel!
    @IBOutlet weak var glaucomaImage: UIImageView!
    
    static var condition = String()
    static var rightEye = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ChooseDiseaseView.rightEye = false
        
    }
    @IBAction func glaucomaClicked(_ sender: Any) {
        switchingEyes()
        if (ChooseDiseaseView.rightEye == false) {
            let pastCondition = ChooseDiseaseView.condition
            let currentCondition = "Glaucoma"
            if (pastCondition != currentCondition) {
                // alert, cannot start a new test without finsihing the old one. No segue performed
                // create the alert
                let alert = UIAlertController(title: "Testing in Progress", message: "You currently started testing for another disease. Would you like to start over and test for this disease?", preferredStyle: UIAlertController.Style.alert)
                
                // add the actions (buttons)
                alert.addAction(UIAlertAction(title: "Yes", style: UIAlertAction.Style.default, handler:{ action in
                    ChooseDiseaseView.condition = "Glaucoma"
                    ChooseDiseaseView.rightEye = true
                    self.performSegue(withIdentifier: "toGlaucomaTesting", sender: nil)
                }))
                
                alert.addAction(UIAlertAction(title: "No", style: UIAlertAction.Style.default, handler: { action in
                    self.switchingEyes()
                    
                }))
                
                // show the alert
                self.present(alert, animated: true, completion: nil)
                
            }
            
            else {
                //perform segue to the next screen
                performSegue(withIdentifier: "toGlaucomaTesting", sender: nil)
            }
        }
        
        else if (ChooseDiseaseView.rightEye == true){
            //If this is the first eye that is being tested, set condition and segue
            ChooseDiseaseView.condition = "Glaucoma"
            performSegue(withIdentifier: "toGlaucomaTesting", sender: nil)
        }
        
    }
    @IBAction func cataractsClicked(_ sender: Any) {
        switchingEyes()
        if (ChooseDiseaseView.rightEye == false) {
            let pastCondition = ChooseDiseaseView.condition
            let currentCondition = "Cataracts"
            
            if (pastCondition != currentCondition) {
                // alert, cannot start a new test without finsihing the old one. No segue performed
                // create the alert
                let alert = UIAlertController(title: "Testing in Progress", message: "You currently started testing for another disease. Would you like to start over and test for this disease?", preferredStyle: UIAlertController.Style.alert)
                
                // add the actions (buttons)
                alert.addAction(UIAlertAction(title: "Yes", style: UIAlertAction.Style.default, handler:{ action in
                    ChooseDiseaseView.condition = "Cataracts"
                    ChooseDiseaseView.rightEye = true
                    self.performSegue(withIdentifier: "toCataractsTesting", sender: nil)
                }))
                
                alert.addAction(UIAlertAction(title: "No", style: UIAlertAction.Style.default, handler:{ action in
                    self.switchingEyes()
                }))
                
                // show the alert
                self.present(alert, animated: true, completion: nil)
                
            }
            
            else {
                //perform segue to the next screen
                performSegue(withIdentifier: "toCataractsTesting", sender: nil)
            }
            
        }
        
        else if (ChooseDiseaseView.rightEye == true){
            //If this is the first eye that is being tested, set condition and segue
            ChooseDiseaseView.condition = "Cataracts"
            performSegue(withIdentifier: "toCataractsTesting", sender: nil)
        }
    }
    
    func switchingEyes() {
        let currentEye = ChooseDiseaseView.rightEye
        if (currentEye == true) {
            ChooseDiseaseView.rightEye = false
        }
        
        else {
            ChooseDiseaseView.rightEye = true
        }
    }
}
