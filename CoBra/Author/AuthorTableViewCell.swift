//
//  AuthorTableViewCell.swift
//  CoBra
//
//  Created by Juan José Hernández Alonso on 17/1/18.
//  Copyright © 2018 Universidad San Jorge. All rights reserved.
//

import UIKit

class AuthorTableViewCell: UITableViewCell {

    @IBOutlet weak var authorNameLabel: UILabel!
    
    var author : Author? {
        didSet {
            guard author != nil else {
                return
            }
            let text = "\(author!.surname ?? ""), \(author!.name ?? "")"
            if text != ", " {
                authorNameLabel.text = text
            } else {
                authorNameLabel.text = ""
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
