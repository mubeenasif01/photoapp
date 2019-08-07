//
//  galleryCell.swift
//  App
//
//  Created by M.Mubeen Asif on 06/08/2019.
//  Copyright © 2019 M.Mubeen Asif. All rights reserved.
//

import UIKit

protocol imbgecellDelegate {
    func deleteimage(indexPath: Int)
}

class galleryCell: UICollectionViewCell {
    
    var delegate: imbgecellDelegate?
    var indexPath: IndexPath?
    
    @IBOutlet weak var imagevu: UIImageView!
    
    @IBAction func deleteBtn(_ sender: Any) {
        delegate?.deleteimage(indexPath: indexPath!.row )
    }
}
