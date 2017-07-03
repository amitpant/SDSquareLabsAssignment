//
//  ImageCollectionViewCell.swift
//  SDSquareAssignment
//
//  Created by Amit Pant on 03/07/17.
//  Copyright © 2017 Amit Pant. All rights reserved.
//

import UIKit

class ImageCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var imageView: UIImageView!{
        didSet {
             imageView.layer.borderColor = UIColor.black.cgColor
             imageView.layer.borderWidth = 0.5
        }
    }
}
