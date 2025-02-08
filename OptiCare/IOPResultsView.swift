//
//  IOPResultsView.swift
//  OptiCare
//
//  Created by Isha Nagireddy on 1/14/24.
//

import Charts
import CoreData
import UIKit

class IOPResultsView: UIViewController, ChartViewDelegate {
    
    @IBOutlet weak var nextStepsButton: UIButton!
    @IBOutlet weak var resultLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var lineChart: LineChartView!
    
    static var IOP = false
    
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var pressures: [Test]?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        lineChart.delegate = self
        
        do {
            pressures = try context.fetch(Test.fetchRequest())
            let firstEntry = pressures![0].pressure
            let lastEntry = pressures![pressures!.count - 1].pressure
            
            let slope = (lastEntry - firstEntry) / Double(pressures!.count)
            
            // this is an arbitrary number
            if (slope >= 0.3) {
                resultLabel.text = "There are signs of glaucoma."
                IOPResultsView.IOP = true
                self.nextStepsButton.setTitle("Take the severity questionaire", for: .normal)
            }
            
            else {
                resultLabel.text = "There are no signs of glaucoma."
                IOPResultsView.IOP = false
                self.nextStepsButton.setTitle("Return home", for: .normal)
            }
        }
        
        catch {
            print(error)
        }
        
    }
    
    @IBAction func nextStepsButtonClicked(_ sender: Any) {
        if (IOPResultsView.IOP == false) {
            performSegue(withIdentifier: "toSeverityFromIOP", sender: nil)
        }
        
        else {
            performSegue(withIdentifier: "toTestingAgainGlaucoma", sender: nil)
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        var entries = [ChartDataEntry]()
        for i in 0...pressures!.count - 1 {
            entries.append(ChartDataEntry(x: Double(i), y:pressures![i].pressure))
        }
        
        let set = LineChartDataSet(entries: entries)
        set.colors = ChartColorTemplates.joyful()
        let data = LineChartData(dataSet: set)
        lineChart.data = data
    }
}
