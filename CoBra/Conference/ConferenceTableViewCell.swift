//
//  ConferenceTableViewCell.swift
//  CoBra
//
//  Created by Juan José Hernández Alonso on 17/1/18.
//  Copyright © 2018 Universidad San Jorge. All rights reserved.
//

import UIKit

class ConferenceTableViewCell: UITableViewCell {

    @IBOutlet weak var conferenceNameLabel: UILabel!
    
    var conference : Conference?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        guard conference != nil else {
            return
        }
        let text = "\(conference!.name ?? "")"
        conferenceNameLabel.text = text
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
