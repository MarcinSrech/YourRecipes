//
//  PhotoTableViewCell.swift
//  YourRecipes
//
//  Created by user908549 on 11/26/17.
//  Copyright © 2017 Marcin Srech. All rights reserved.
//

import UIKit

class PhotoTableViewCell: UITableViewCell {
    
    //MARK: - Outlets
    @IBOutlet weak var photoImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
