//
//  CollectionViewCell.swift
//  FirebaseInClass01
//
//  Created by Kabra, Sunidhi on 11/19/18.
//  Copyright © 2018 UNC Charlotte. All rights reserved.
//

import UIKit

class CollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var imageView: UIImageView!
    
    func displayContent(image: UIImage){
        imageView.image = image
    }
}
