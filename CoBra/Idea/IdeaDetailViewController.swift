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
        authorsTableView.dataSource = self
        ideaTitleLabel.text = idea!.title
        ideaDescriptionTextView.text = idea!.idea_description
        conferenceNameButton.setTitle(idea!.conference?.name ?? "No conference", for: .normal)
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showConferenceDetail" {
            let navigationController = segue.destination as! UINavigationController
            let conferenceDetailViewController = navigationController.viewControllers.first as! ConferenceDetailViewController
            conferenceDetailViewController.conference = idea?.conference
        }
    }
}

// MARK: - Table view data source

extension IdeaDetailViewController : UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if idea?.authors?.count ?? 0 > 0 {
            return idea?.authors?.count ?? 0
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var author : Author
        author = idea?.authors?.allObjects[indexPath.row] as! Author
        let cell = authorsTableView.dequeueReusableCell(withIdentifier: "IdeaAuthorCell", for: indexPath) as! AuthorTableViewCell
        cell.author = author
        return cell
    }
    
}


