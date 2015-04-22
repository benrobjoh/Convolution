//
//  FilterCollectionViewCell.swift
//  Convolution
//
//  Created by Ben Johnson on 4/15/15.
//  Copyright (c) 2015 Bixelcog LLC. All rights reserved.
//

import UIKit

class FilterCollectionViewCell: UICollectionViewCell {
    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    
    var image: UIImage? {
        didSet {
            imageView?.image = image
        }
    }
    
    var title: String? {
        didSet {
            titleLabel?.text = title
        }
    }
}
