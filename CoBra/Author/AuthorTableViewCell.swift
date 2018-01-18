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
            let text = "\(author!.surname ?? ""), \(author!.name ?? "")"
            if text != ", " {
                authorNameLabel.text = text
            } else {
                authorNameLabel.text = ""
            }
        }
    }

}
