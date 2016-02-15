//
//  FeedTableViewCell.swift
//  PersistenceNetworkingUoT
//
//  Created by Karlo Pagtakhan on 02/15/2016.
//  Copyright © 2016 AccessIT. All rights reserved.
//

import UIKit

class FeedTableViewCell: UITableViewCell {

  @IBOutlet var feedImage: UIImageView!
  @IBOutlet var feedText: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
