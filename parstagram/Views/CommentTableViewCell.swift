//
//  CommentTableViewCell.swift
//  parstagram
//
//  Created by Richard Hsu on 2020/2/23.
//  Copyright © 2020 Richard Hsu. All rights reserved.
//

import UIKit

class CommentTableViewCell: UITableViewCell {
    
    // MARK: - Variables
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var commentLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
