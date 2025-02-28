//
//  CoachingCell.swift
//  UlusoyWorkout
//
//  Created by Mert Ziya on 26.02.2025.
//

import UIKit

class CoachingCell: UICollectionViewCell {
    // Properties:
    static let nibName = "CoachingCell"
    static let identifier = "CoachingCellIdentifier"
    static let cellWidth : CGFloat = 288
    
    // UI Components:
    @IBOutlet weak var contentImage: UIImageView!
    @IBOutlet weak var monthLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var wrapperView: UIView!
    

   
    
    override func awakeFromNib() {
        super.awakeFromNib()
        configureCellUI()
        // Initialization code
    }

    
    private func configureCellUI(){
        clipsToBounds = false
        backgroundColor = .appCell
        layer.cornerRadius = 24
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = CGSize(width: -2, height: 2)
        layer.shadowOpacity = 0.5
        layer.shadowRadius = 4
    }
    
    func configureCell(with coaching : Coaching , color: UIColor, imageURL : String){
       
        contentImage.layer.cornerRadius = 24
        contentImage.clipsToBounds = true

        
        wrapperView.layer.cornerRadius = 24
        wrapperView.layer.shadowColor = color.cgColor
        wrapperView.layer.shadowOffset = CGSize(width: 0, height: 0)
        wrapperView.layer.shadowOpacity = 1
        wrapperView.layer.shadowRadius = 12
       
        
        ImageLoader.getImage(from: imageURL, completion: { image in
            DispatchQueue.main.async {
                self.contentImage.image = image
            }
        })
        
        monthLabel.text = coaching.month
        priceLabel.text = coaching.price
        priceLabel.textColor = .appGreen
        
        descriptionLabel.text = ""
        for detail in coaching.details ?? [] {
            descriptionLabel.text! += "• \(detail)\n"
        }
        
    }

}
