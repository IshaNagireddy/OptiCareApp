//
//  ResourcesDetailView.swift
//  OptiCare
//
//  Created by Isha Nagireddy on 1/14/24.
//

import UIKit
import youtube_ios_player_helper

class ResourcesDetailView: UIViewController {
    
    @IBOutlet var playerView: YTPlayerView!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var questionLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        let range = ResourcesView.questions.count
        questionLabel.text = ResourcesView.chosenQuestion
        
        for i in  0...range - 1 {
            if (ResourcesView.chosenQuestion == ResourcesView.questions[i]) {
                let chosenID = ResourcesView.videoIDs[i]
                let chosenDescription = ResourcesView.descriptions[i]
                playerView.load(withVideoId: chosenID)
                descriptionLabel.text = chosenDescription
                
            }
            
        }
        
    }
    

}
