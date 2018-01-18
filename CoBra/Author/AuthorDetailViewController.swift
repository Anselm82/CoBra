//
//  AuthorDetailViewController.swift
//  CoBra
//
//  Created by Juan José Hernández Alonso on 16/1/18.
//  Copyright © 2018 Universidad San Jorge. All rights reserved.
//

import UIKit

class AuthorDetailViewController: UIViewController {
    
    @IBOutlet weak var authorNameLabel: UILabel!
    @IBOutlet weak var authorSurnameLabel: UILabel!
    @IBOutlet weak var authorAffiliationLabel: UILabel!
    
    var author : Author?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        guard author != nil else {
            return
        }
        authorNameLabel.text = author!.name
        authorSurnameLabel.text = author!.surname
        authorAffiliationLabel.text = author!.affiliation
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
