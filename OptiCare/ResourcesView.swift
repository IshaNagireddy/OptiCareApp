//
//  ResourcesView.swift
//  OptiCare
//
//  Created by Isha Nagireddy on 1/14/24.
//

import UIKit

class ResourcesView: UIViewController {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var resourcesTable: UITableView!
    @IBOutlet weak var eyeImage: UIImageView!
    @IBOutlet weak var resourcesDecriptionLabel: UILabel!
    
    static let questions = ["How do you create the fundus imager?", "How do you take fundus images?", "How do you use the slip lamp?", "How do you use the IOP tool?"]
    static let videoIDs = ["kVWVut-mUWc", "I4ySI2hW4ik", "pdaBLPwt8-8", "pdaBLPwt8-8"]
    
    static let descriptions = ["Materials: The 3D printed stl files needed to make the oDocs fundus imager is freee and avaiable on the oDocs website.", "Tips: Make sure that the lans is 5-6 centimers away from the person's eye!", "Tips: Make sure that the phone is around 2 centimers away from the person's eye!", "Tips: Specific instructions here."]
    static var chosenQuestion = String()
    override func viewDidLoad() {
        super.viewDidLoad()
        resourcesTable.delegate = self
    }

}

extension ResourcesView: UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        ResourcesView.questions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = ResourcesView.questions[indexPath.row]
        cell.textLabel?.textColor = UIColor(red: 0.36, green: 0.49, blue: 0.58, alpha: 1.0)
        cell.textLabel?.font = UIFont.init(name: "Poppins-Regular", size: 14)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        ResourcesView.chosenQuestion = ResourcesView.questions[indexPath.row]
        performSegue(withIdentifier: "toResourcesDetail", sender: nil)
    }
    
    
}
