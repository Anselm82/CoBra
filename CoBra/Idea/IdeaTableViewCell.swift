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
    
    var idea : Idea? {
        didSet {
            let text = "\(idea?.title ?? "")"
            ideaTitleLabel.text = text
        }
    }
    
}
