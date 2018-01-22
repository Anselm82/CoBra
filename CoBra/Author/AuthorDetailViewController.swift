//
//  AuthorDetailViewController.swift
//  CoBra
//
//  Created by Juan José Hernández Alonso on 16/1/18.
//  Copyright © 2018 Universidad San Jorge. All rights reserved.
//

import UIKit

class AuthorDetailViewController: UIViewController {
    
    // Outlets
    @IBOutlet weak var authorNameLabel: UILabel!
    @IBOutlet weak var authorSurnameLabel: UILabel!
    @IBOutlet weak var authorAffiliationLabel: UILabel!
    
    @IBAction func done() {
        dismiss(animated: true, completion: nil)
    }
    
    var author : Author?
    
    // Prepare view
    override func viewDidLoad() {
        super.viewDidLoad()
        guard author != nil else {
            return
        }
        authorNameLabel.text = author!.name
        authorSurnameLabel.text = author!.surname
        authorAffiliationLabel.text = author!.affiliation
    }

}
