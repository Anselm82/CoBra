//
//  IdeaTableViewCell.swift
//  CoBra
//
//  Created by Juan José Hernández Alonso on 17/1/18.
//  Copyright © 2018 Universidad San Jorge. All rights reserved.
//

import UIKit

class IdeaTableViewCell: UITableViewCell {

    @IBOutlet weak var ideaTitleLabel: UILabel!
    
    var idea : Idea?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        guard idea != nil else {
            return
        }
        let text = "\(idea!.title ?? "")"
        ideaTitleLabel.text = text
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
