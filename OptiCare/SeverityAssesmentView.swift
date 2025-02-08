//
//  SeverityAssesmentView.swift
//  OptiCare
//
//  Created by Isha Nagireddy on 1/14/24.
//

import UIKit

class SeverityAssesmentView: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    

    @IBOutlet weak var questionLabel: UILabel!
    @IBOutlet weak var button1: UIButton!
    @IBOutlet weak var button2: UIButton!
    @IBOutlet weak var button3: UIButton!
    @IBOutlet weak var button4: UIButton!
    @IBOutlet weak var button5: UIButton!
    @IBOutlet weak var button6: UIButton!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var takeAssesmentLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var pageController: UIPageControl!
    
    var glaucomaSlides = [CollectionViewOptions(questionLabel: "Reading newspapers: "), CollectionViewOptions(questionLabel: "Walking after dark: "), CollectionViewOptions(questionLabel: "Seeing at night: "), CollectionViewOptions(questionLabel: "Walking on uneven ground: "), CollectionViewOptions(questionLabel: "Adjusting to bright lights: "), CollectionViewOptions(questionLabel: "Adjusting to dim lights: "), CollectionViewOptions(questionLabel: "Going from a light to dark room or vice versa: "), CollectionViewOptions(questionLabel: "Tripping over objects: "), CollectionViewOptions(questionLabel: "Seeing object coming from the side: "), CollectionViewOptions(questionLabel: "Crossing the road: "), CollectionViewOptions(questionLabel: "Walking on steps/stairs: "), CollectionViewOptions(questionLabel: "Bumping into objects: "), CollectionViewOptions(questionLabel: "Judging distance of foot to step/curb: "), CollectionViewOptions(questionLabel: "Finding dropped objects: "), CollectionViewOptions(questionLabel: "Recognizing faces: ")]
    
    var cataractsSlides = [CollectionViewOptions(questionLabel: "Do you have any difficulty, even with glasses, reading small print, such as labels on medicine bottles, a telephone book, food labels?"), CollectionViewOptions(questionLabel: "Do you have any difficulty, even with glasses, reading a newspaper or a book? "), CollectionViewOptions(questionLabel: "Do you have any difficulty, even with glasses, recoganizing people when they are close to you?"), CollectionViewOptions(questionLabel: "Do you have any difficulty, even with glasses, seeing steps, stairs, or curbs?"), CollectionViewOptions(questionLabel: "Do you have any difficulty, even with glasses, reading traffic signs, street signs, or store signs?"), CollectionViewOptions(questionLabel: "Do you have any difficulty, even with glasses, doing find handwork like seing and knitting?"), CollectionViewOptions(questionLabel: "Do you have any difficulty, even with glasses, writing checks or filling out forms?"), CollectionViewOptions(questionLabel: "Do you have any difficulty, even with glasses, playing games such as bingo and dominos?"), CollectionViewOptions(questionLabel: "Do you have any difficulty, even with glasses, taking part in sports like bowling and handball?"), CollectionViewOptions(questionLabel: "Crossing the road: "), CollectionViewOptions(questionLabel: "Do you have any difficulty, even with glasses, cooking?"), CollectionViewOptions(questionLabel: "Do you have any difficulty, even with glasses, watching television?"), CollectionViewOptions(questionLabel: "How much difficulty do you have driving during the day because of your vision?"), CollectionViewOptions(questionLabel: "How much difficulty do you have driving at night because of your vision? "),]
    
    var currentPage = 0
    static var totalScore = 0
    var finalSlides = [CollectionViewOptions]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if (ChooseDiseaseView.condition == "Glaucoma") {
            finalSlides = glaucomaSlides
        }
        
        else {
            finalSlides = cataractsSlides
        }
        
    }
    
    @IBAction func OneClicked(_ sender: Any) {
        if currentPage == 14 {
            
            performSegue(withIdentifier: "toSummaryPage", sender: nil)
        }
        
        else {
            
            SeverityAssesmentView.totalScore += 1
            pageController.currentPage = currentPage
            
            let rect = self.collectionView.layoutAttributesForItem(at: IndexPath(row: currentPage, section: 0))?.frame
            self.collectionView.scrollRectToVisible(rect!, animated: true)
            currentPage += 1
        }
    }
    @IBAction func twoClicked(_ sender: Any) {
        if currentPage == 14 {
            
            performSegue(withIdentifier: "toSummaryPage", sender: nil)
        }
        
        else {
            
            SeverityAssesmentView.totalScore += 2
            pageController.currentPage = currentPage
            
            let rect = self.collectionView.layoutAttributesForItem(at: IndexPath(row: currentPage, section: 0))?.frame
            self.collectionView.scrollRectToVisible(rect!, animated: true)
            currentPage += 1
        }
    }
    @IBAction func threeClicked(_ sender: Any) {
        if currentPage == 14 {
            
            performSegue(withIdentifier: "toSummaryPage", sender: nil)
        }
        
        else {
            
            SeverityAssesmentView.totalScore += 3
            pageController.currentPage = currentPage
            
            let rect = self.collectionView.layoutAttributesForItem(at: IndexPath(row: currentPage, section: 0))?.frame
            self.collectionView.scrollRectToVisible(rect!, animated: true)
            currentPage += 1
        }
    }
    @IBAction func fourClicked(_ sender: Any) {
        if currentPage == 14 {
            
            performSegue(withIdentifier: "toSummaryPage", sender: nil)
        }
        
        else {
            
            SeverityAssesmentView.totalScore += 4
            pageController.currentPage = currentPage
            
            let rect = self.collectionView.layoutAttributesForItem(at: IndexPath(row: currentPage, section: 0))?.frame
            self.collectionView.scrollRectToVisible(rect!, animated: true)
            currentPage += 1
        }
    }
    @IBAction func fiveClicked(_ sender: Any) {
        if currentPage == 14 {
            
            performSegue(withIdentifier: "toSummaryPage", sender: nil)
        }
        
        else {
            
            SeverityAssesmentView.totalScore += 5
            pageController.currentPage = currentPage
            
            let rect = self.collectionView.layoutAttributesForItem(at: IndexPath(row: currentPage, section: 0))?.frame
            self.collectionView.scrollRectToVisible(rect!, animated: true)
            currentPage += 1
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        finalSlides.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell  = collectionView.dequeueReusableCell(withReuseIdentifier: CollectionViewCell.identifier, for: indexPath) as! CollectionViewCell
        cell.setup(slide: glaucomaSlides[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
    }
    
    
}
