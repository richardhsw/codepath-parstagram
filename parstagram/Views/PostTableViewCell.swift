//
//  PostTableViewCell.swift
//  parstagram
//
//  Created by Richard Hsu on 2020/2/17.
//  Copyright © 2020 Richard Hsu. All rights reserved.
//

import UIKit

class PostTableViewCell: UITableViewCell {
    
    // MARK: - Variables
    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var captionLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
