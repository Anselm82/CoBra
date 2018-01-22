//
//  AddAuthorViewController.swift
//  CoBra
//
//  Created by Juan José Hernández Alonso on 16/1/18.
//  Copyright © 2018 Universidad San Jorge. All rights reserved.
//

import UIKit
import CoreData

class AuthorAddViewController: UIViewController {

    // Outlets
    @IBOutlet weak var authorNameTextField: UITextField!
    @IBOutlet weak var authorSurnameTextField: UITextField!
    @IBOutlet weak var authorAffiliationTextField: UITextField!
    
    var previous : AuthorTableViewController?
    
    lazy var context : NSManagedObjectContext = {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let persistenContainer = appDelegate.persistentContainer
        return persistenContainer.viewContext
    }()
    
    // Make persistent
    @IBAction func saveAuthor(_ sender: Any) {
        
        // Data is set
        guard authorNameTextField.text?.count ?? 0 > 0,
        authorSurnameTextField.text?.count ?? 0 > 0,
        authorAffiliationTextField.text?.count ?? 0 > 0 else {
            let alert = UIAlertController(title: "Create author", message: "Please, complete all the fields.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
            self.present(alert, animated: false, completion: nil)
            return
        }
        
        // Check existence
        let authorFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "Author")
        let namePredicate = NSPredicate(format: "name == %@", authorNameTextField.text!)
        let surnamePredicate = NSPredicate(format: "surname == %@", authorSurnameTextField.text!)
        let affiliationPredicate = NSPredicate(format: "affiliation == %@", authorAffiliationTextField.text!)
        let multiplePredicates = NSCompoundPredicate(type: .and, subpredicates: [namePredicate, surnamePredicate, affiliationPredicate])
        authorFetch.predicate = multiplePredicates
        do {
            let fetchedAuthors = try context.fetch(authorFetch) as! [Author]
            
            // If is new, insert
            if fetchedAuthors.count == 0 {
                let author = NSEntityDescription.insertNewObject(forEntityName: "Author", into: context) as! Author
                author.name = authorNameTextField.text
                author.surname = authorSurnameTextField.text
                author.affiliation = authorAffiliationTextField.text
                try? context.save()
                previous?.tableView.reloadData()
                dismiss(animated: true, completion: nil)
            } else {
                let alert = UIAlertController(title: "Create author", message: "Author already exists.", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
                self.present(alert, animated: false, completion: nil)
            }
        } catch {
            
            // Development stage default error handling 
            fatalError("Failed to fetch employees: \(error)")
        }
        
    }
    
    // Cancel action
    @IBAction func cancel(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    // Prepare view
    override func viewDidLoad() {
        super.viewDidLoad()
        authorNameTextField.becomeFirstResponder()
    }

}
