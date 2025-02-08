//
//  SummaryView.swift
//  OptiCare
//
//  Created by Isha Nagireddy on 1/14/24.
//

import UIKit

class SummaryView: UIViewController {

    @IBOutlet weak var questionaireLabel: UILabel!
    @IBOutlet weak var chanceLabel: UILabel!
    @IBOutlet weak var summaryLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var nextStepsButton: UIButton!
    @IBOutlet weak var contactButton: UIButton!
    @IBOutlet weak var treatmentLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        questionaireLabel.text = "Due to the high results, the risk questionaire was taken and a score of \(SeverityAssesmentView.totalScore) was achieved."
        
    }
    
    @IBAction func nextStepsButtonClicked(_ sender: Any) {
        performSegue(withIdentifier: "returnHome", sender: nil)
    }
    
    
}
