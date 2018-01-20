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
    
    
    @IBOutlet weak var ideaTitleLabel: UILabel!
    @IBOutlet weak var ideaDescriptionTextView: UITextView!
    @IBOutlet weak var conferenceNameButton: UIButton!
    @IBOutlet weak var authorsTableView: UITableView!
    
    @IBAction func export(_ sender: Any) {
        let eventStore : EKEventStore = EKEventStore()
        
        eventStore.requestAccess(to: .event) { (granted, error) in
            
            if (granted) && (error == nil) {
                let event:EKEvent = EKEvent(eventStore: eventStore)
                event.title = self.idea?.title
                event.startDate = self.idea?.conference?.abstract_deadline
                event.endDate = self.idea?.conference?.abstract_deadline
                event.notes = self.idea?.idea_description
                event.calendar = eventStore.defaultCalendarForNewEvents
                let article:EKEvent = EKEvent(eventStore: eventStore)
                article.title = self.idea?.title
                article.startDate = self.idea?.conference?.article_deadline
                article.endDate = self.idea?.conference?.article_deadline
                article.notes = self.idea?.idea_description
                article.calendar = eventStore.defaultCalendarForNewEvents
                do {
                    try eventStore.save(event, span: .thisEvent)
                    try eventStore.save(article, span: .thisEvent)
                } catch let error as NSError {
                    print("failed to save event with error : \(error)")
                }
                print("Saved Events")
            } else{
                print("failed to save event with error : \(String(describing: error)) or access not granted")
            }
        }
    }
    
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


