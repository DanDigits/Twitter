//
//  TweetTableViewCell.swift
//  Twitter
//
//  Created by Daniel Cruz Castro on 10/4/21.
//  Copyright © 2021 Dan. All rights reserved.
//

import UIKit

class TweetTableViewCell: UITableViewCell {
    // Declarations
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var profileNameLabel: UILabel!
    @IBOutlet weak var tweetContentLabel: UILabel!
    
    // Body
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

// Functions
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
