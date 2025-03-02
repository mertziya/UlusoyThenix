//
//  PackageCell.swift
//  UlusoyWorkout
//
//  Created by Mert Ziya on 2.03.2025.
//

import Foundation
import FSPagerView

class PackageCell : FSPagerViewCell{
    
    static let nibName = "PackageCell"
    static let identifier = "PackageIdentifier"
    
    @IBOutlet weak var wrapperView: UIView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    @IBOutlet weak var imageWrapper: UIView!
    @IBOutlet weak var contentImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        configureCellUI()
    }
    
    
    private func configureCellUI(){
        contentImage.layer.cornerRadius = 24
        contentImage.clipsToBounds = true
        
        imageWrapper.layer.cornerRadius = 24
        imageWrapper.backgroundColor = .clear
        imageWrapper.clipsToBounds = false
        
        imageWrapper.layer.shadowColor = UIColor.black.cgColor
        imageWrapper.layer.shadowRadius = 2
        imageWrapper.layer.shadowOpacity = 0.4
        imageWrapper.layer.shadowOffset = CGSize(width: 0, height: 0)
        
        wrapperView.backgroundColor = .appCell
        wrapperView.layer.cornerRadius = 24
        
        wrapperView.layer.shadowColor = UIColor.black.cgColor
        wrapperView.layer.shadowRadius = 4
        wrapperView.layer.shadowOpacity = 0.8
        wrapperView.layer.shadowOffset = CGSize(width: 0, height: 0)
                
    }
    
    func configureCell(with package : ReadyPackage){
        ImageLoader.getImage(from: package.imageURL) { image in
            DispatchQueue.main.async {
                self.contentImage.image = image
            }
        }
        
        print("test")
        
        nameLabel.text = package.name
        
        priceLabel.text = package.price
        
        descriptionLabel.text = package.description
    }
    
    
}
