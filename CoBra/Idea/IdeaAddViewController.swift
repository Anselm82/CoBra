//
//  IdeaAddViewController.swift
//  CoBra
//
//  Created by Juan José Hernández Alonso on 18/1/18.
//  Copyright © 2018 Universidad San Jorge. All rights reserved.
//

import UIKit
import CoreData

class IdeaAddViewController: UIViewController {

    var idea : Idea?
    var authors : [Author]?
    
    @IBOutlet weak var authorsButton: UIButton!
    
    lazy var context : NSManagedObjectContext = {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let persistenContainer = appDelegate.persistentContainer
        return persistenContainer.viewContext
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        idea = (NSEntityDescription.insertNewObject(forEntityName: "Idea", into: context) as! Idea)
    }

    override func viewWillAppear(_ animated: Bool) {
        if authors?.count ?? 0 > 0 {
            var text = ""
            var count = 0
            for author in authors! {
                text += "\(String(describing: author.name)) \(String(describing: author.surname))"
                if count != authors?.count {
                    text += ", "
                }
                count += 1
            }
            authorsButton.titleLabel?.text = text
        }
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "selectAuthor" {
            let ideaAuthorTableViewController = segue.destination  as! IdeaAuthorTableViewController
            ideaAuthorTableViewController.previous = self
        }
    }

}
