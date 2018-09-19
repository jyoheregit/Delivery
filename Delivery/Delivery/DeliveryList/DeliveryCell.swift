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
        imageView.contentMode = UIViewContentMode.scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    lazy var stackView : UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.alignment = .fill
        stackView.addArrangedSubview(descriptionLabel)
        return stackView
    }()
    
    lazy var descriptionLabel : UILabel = {
        let descriptionLabel = UILabel()
        descriptionLabel.numberOfLines = 0
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        return descriptionLabel
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        //self.backgroundColor = UIColor.blue
        self.layer.borderColor = UIColor.black.cgColor
        self.layer.borderWidth = 1.0
        self.contentView.addSubview(imageView)
        //let edges = Constants.StandardSpacing.edges
        let between = Constants.StandardSpacing.between
        
        imageView.anchor(top: (anchor: self.topAnchor, constant: 0.0), leading: (anchor: self.leadingAnchor, constant: 0.0),
                         bottom: nil, trailing: nil)
        imageView.widthAnchor.activateConstraint(equalToConstant: 181)
        imageView.heightAnchor.activateConstraint(equalToConstant: 100)
        
        self.contentView.addSubview(stackView)
        stackView.anchor(top: (anchor: imageView.topAnchor, constant: 0.0),
                         leading: (anchor: self.imageView.trailingAnchor, constant: between),
                         bottom: (self.bottomAnchor, constant: 0.0),
                        trailing: (anchor: self.trailingAnchor, constant: between))
        
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
