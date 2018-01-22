//
//  IdeaDetailViewController.swift
//  CoBra
//
//  Created by Juan José Hernández Alonso on 17/1/18.
//  Copyright © 2018 Universidad San Jorge. All rights reserved.
//

import UIKit
import EventKit

class IdeaDetailViewController: UIViewController {
    
    var idea : Idea?
    
    // Outlets
    @IBOutlet weak var ideaTitleLabel: UILabel!
    @IBOutlet weak var ideaDescriptionTextView: UITextView!
    @IBOutlet weak var conferenceNameButton: UIButton!
    @IBOutlet weak var authorsTableView: UITableView!
    
    // Export events to iCal, needs info.plist declaration
    @IBAction func export(_ sender: Any) {
        let eventStore : EKEventStore = EKEventStore()
        
        eventStore.requestAccess(to: .event) { (granted, error) in
            // If permission granted and no errors
            if (granted) && (error == nil) {
                // Create one event that will be registered twice (abstract and article deadlines)
                let event:EKEvent = EKEvent(eventStore: eventStore)
                event.title = self.idea?.title
                event.startDate = self.idea?.conference?.abstract_deadline
                event.endDate = self.idea?.conference?.abstract_deadline
                event.notes = self.idea?.idea_description
                event.calendar = eventStore.defaultCalendarForNewEvents
                try? eventStore.save(event, span: .thisEvent)
                event.startDate = self.idea?.conference?.article_deadline
                event.endDate = self.idea?.conference?.article_deadline
                try? eventStore.save(event, span: .thisEvent)
            } else{
                print("failed to save event with error : \(String(describing: error)) or access not granted")
            }
        }
    }
    
    // Prepare view
    override func viewDidLoad() {
        super.viewDidLoad()
        guard idea != nil else {
            return
        }
        authorsTableView.dataSource = self
        ideaTitleLabel.text = idea!.title
        ideaDescriptionTextView.text = idea!.idea_description
        conferenceNameButton.setTitle(idea!.conference?.acronym ?? "No conference", for: .normal)
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showConferenceDetail" {
            let navigationController = segue.destination as! UINavigationController
            let conferenceDetailViewController = navigationController.viewControllers.first as! ConferenceDetailViewController
            conferenceDetailViewController.conference = idea?.conference
        } else if segue.identifier == "showAuthorDetail" {
            var author: Author
            // Load author from cell, CoreData is not needed
            if (authorsTableView.indexPathForSelectedRow?.row) != nil {
                author = (authorsTableView.cellForRow(at: authorsTableView.indexPathForSelectedRow!) as! AuthorTableViewCell).author!
                let navigationViewController = segue.destination as! UINavigationController
                let detailViewController = navigationViewController.viewControllers.first as! AuthorDetailViewController
                detailViewController.author = author
            }
        }
    }
}

// MARK: - Table view data source

extension IdeaDetailViewController : UITableViewDataSource {
    
    // Fixed number
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if idea?.authors?.count ?? 0 > 0 {
            return idea?.authors?.count ?? 0
        }
        return 0
    }
    
    // Prepare cell for author
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var author : Author
        author = idea?.authors?.allObjects[indexPath.row] as! Author
        let cell = authorsTableView.dequeueReusableCell(withIdentifier: "IdeaAuthorCell", for: indexPath) as! AuthorTableViewCell
        cell.author = author
        return cell
    }
    
}


