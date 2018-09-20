//
//  DeliveryCell.swift
//  Delivery
//
//  Created by Joe on 15/09/18.
//  Copyright © 2018 Jyothish. All rights reserved.
//

import UIKit
import SDWebImage

class DeliveryCell : UICollectionViewCell {
    
    var delivery : Delivery? {
        didSet {
            if let delivery = delivery {
                self.descriptionLabel.text = delivery.descriptionText()
                
                if let imageUrl = delivery.imageUrl {
                    self.imageView.sd_setImage(with: URL(string: imageUrl), placeholderImage: #imageLiteral(resourceName: "placeholder"))
                }
            }
        }
    }
    
    lazy var imageView : UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = UIView.ContentMode.scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    lazy var descriptionLabel : UILabel = {
        let descriptionLabel = UILabel()
        descriptionLabel.numberOfLines = 0
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        descriptionLabel.font = UIFont(name: "HelveticaNeue", size:16)
        return descriptionLabel
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.layer.borderColor = UIColor.lightGray.cgColor
        self.layer.borderWidth = 1.0
        addImageView()
        addDescriptionLabel()
    }
    
    func addImageView() {
        self.contentView.addSubview(imageView)
        imageView.anchor(top: (anchor: self.topAnchor, constant: 0.0),
                         leading: (anchor: self.leadingAnchor, constant: 0.0),
                         bottom: nil, trailing: nil)
        imageView.widthAnchor.activateConstraint(equalToConstant: Constants.ImageView.width)
        imageView.heightAnchor.activateConstraint(equalToConstant: Constants.ImageView.height)

    }
    
    func addDescriptionLabel(){
        let between = Constants.StandardSpacing.between
        self.contentView.addSubview(descriptionLabel)
        descriptionLabel.anchor(top: (anchor: imageView.topAnchor, constant: 2.0),
                                leading: (anchor: self.imageView.trailingAnchor, constant: between),
                                bottom: nil,
                                trailing: (anchor: self.trailingAnchor, constant: between))
        
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
