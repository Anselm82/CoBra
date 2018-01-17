//
//  IdeaDetailViewController.swift
//  CoBra
//
//  Created by Juan José Hernández Alonso on 17/1/18.
//  Copyright © 2018 Universidad San Jorge. All rights reserved.
//

import UIKit

class IdeaDetailViewController: UIViewController {
    
    @IBOutlet weak var ideaTitleLabel: UILabel!
    @IBOutlet weak var ideaDescriptionTextView: UITextView!
    @IBOutlet weak var conferenceNameButton: UIButton!
    @IBOutlet weak var authorsTableView: UITableView!
    
    var idea : Idea?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        guard idea != nil else {
            return
        }
        ideaTitleLabel.text = idea!.title
        ideaDescriptionTextView.text = idea!.idea_description
        conferenceNameButton.titleLabel?.text = idea!.conference?.name ?? "No conference"
        if idea!.authors?.count ?? 0 > 0 {
            for author in idea!.authors! {
                let cell = AuthorTableViewCell()
                cell.author = (author as! Author)
                authorsTableView.addSubview(cell)
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
