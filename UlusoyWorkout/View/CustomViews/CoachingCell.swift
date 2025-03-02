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
    @IBOutlet weak var discountedPriceLabel: UILabel!
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
    
    func configureCell(with coaching : Coaching){
        
        let colorLiteral =  UIColor(hex: coaching.color ?? "000000")
       
        wrapperView.layer.shadowColor = colorLiteral.cgColor
        
        ImageLoader.getImage(from: coaching.imageURL, completion: { image in
            DispatchQueue.main.async {
                self.contentImage.image = image
            }
        })
        
        monthLabel.text = coaching.month
        
        setPrice(with: coaching)
        
        descriptionLabel.text = ""
        for detail in coaching.details ?? [] {
            descriptionLabel.text! += "• \(detail)\n"
        }
        
    }
    
    private func setPrice(with coaching : Coaching){
        
        // Reset price label to clean state
       priceLabel.attributedText = nil
       priceLabel.text = coaching.price
       priceLabel.textColor = .appGreen

       // Reset discounted price label
       discountedPriceLabel.text = ""
        
        if coaching.discountPrice != nil{
            discountedPriceLabel.text = coaching.discountPrice
            discountedPriceLabel.textColor = .appGreen
            let oldPrice = coaching.price ?? ""
            let attributed = NSMutableAttributedString(string: oldPrice)
            
            attributed.addAttributes([
                .strikethroughStyle: NSUnderlineStyle.single.rawValue | NSUnderlineStyle.patternDash.rawValue,
                .strikethroughColor: UIColor.red
            ], range: NSRange(location: 0, length: oldPrice.count))
            
            priceLabel.attributedText = attributed
            priceLabel.textColor = .red
        }
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        self.alpha = 1.0
    }

    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        UIView.animate(withDuration: 0.3) {
            super.touchesCancelled(touches, with: event)
            self.alpha = 1.0
        }
    }

    
    
}
