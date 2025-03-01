//
//  CoachingCell.swift
//  UlusoyWorkout
//
//  Created by Mert Ziya on 26.02.2025.
//

import UIKit
import FSPagerView

class CoachingCell: FSPagerViewCell {
    // Properties:
    static let nibName = "CoachingCell"
    static let identifier = "CoachingCellIdentifier"
    static let cellWidth : CGFloat = 288
    
    // UI Components:
    
    @IBOutlet weak var outerWrapper: UIView!
    @IBOutlet weak var wrapperView: UIView!
    
    @IBOutlet weak var contentImage: UIImageView!
    @IBOutlet weak var monthLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    
   
    
    override func awakeFromNib() {
        super.awakeFromNib()
        configureCellUI()
        // Initialization code
    }

    
    private func configureCellUI() {
        self.backgroundColor = .clear
        self.clipsToBounds = false
        
        wrapperView.backgroundColor = .appCell
        
        
        outerWrapper.layer.cornerRadius = 24
        outerWrapper.layer.shadowColor = UIColor.black.cgColor
        outerWrapper.layer.shadowOffset = CGSize(width: -1, height: 1)
        outerWrapper.layer.shadowOpacity = 0.5
        outerWrapper.layer.shadowRadius = 2
        outerWrapper.layer.masksToBounds = false
    
        contentImage.layer.cornerRadius = 24
        contentImage.clipsToBounds = true
        contentImage.contentMode = .scaleAspectFill

        wrapperView.layer.cornerRadius = 24
        wrapperView.layer.shadowOffset = CGSize(width: 0, height: 0)
        wrapperView.layer.shadowOpacity = 1
        wrapperView.layer.shadowRadius = 12
        
        monthLabel.textColor = .appLabel
        priceLabel.textColor = .appGreen
        descriptionLabel.textColor = .appLabel
      
        
    }
    
    func configureCell(with coaching : Coaching , color: UIColor){
       
        wrapperView.layer.shadowColor = color.cgColor
        
        ImageLoader.getImage(from: coaching.imageURL, completion: { image in
            DispatchQueue.main.async {
                self.contentImage.image = image
            }
        })
        
        monthLabel.text = coaching.month
        
        priceLabel.text = coaching.price
        
        descriptionLabel.text = ""
        for detail in coaching.details ?? [] {
            descriptionLabel.text! += "• \(detail)\n"
        }
        
        
        
    }

}
