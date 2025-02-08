//
//  CollectionViewCell.swift
//  OptiCare
//
//  Created by Isha Nagireddy on 2/14/24.
//

import UIKit

class CollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var questionLabel: UILabel!
    static let identifier = String(describing:CollectionViewCell.self)
    
    func setup(slide: CollectionViewOptions) {
        questionLabel.text = slide.questionLabel
    }
    
}
