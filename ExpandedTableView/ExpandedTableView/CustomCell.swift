//
//  CustomCell.swift
//  ExpandedTableView
//
//  Created by Amar on 16/04/18.
//  Copyright © 2018 brsoftech. All rights reserved.
//

import UIKit

class CustomCell: UITableViewCell {

    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblLeadConstriant: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
