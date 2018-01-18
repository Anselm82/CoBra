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

    @IBOutlet weak var authorNameTextField: UITextField!
    
    @IBOutlet weak var authorSurnameTextField: UITextField!
    
    @IBOutlet weak var authorAffiliationTextField: UITextField!
    
    
    @IBAction func saveAuthor(_ sender: Any) {
        guard authorNameTextField.text?.count ?? 0 > 0,
        authorSurnameTextField.text?.count ?? 0 > 0,
        authorAffiliationTextField.text?.count ?? 0 > 0 else {
            return
        }
        let author = NSEntityDescription.insertNewObject(forEntityName: "Author", into: context) as! Author
        author.name = authorNameTextField.text
        author.surname = authorSurnameTextField.text
        author.affiliation = authorAffiliationTextField.text
        try? context.save()
        previous?.tableView.reloadData()
        dismiss(animated: true, completion: nil)
    }
    
    var previous : AuthorTableViewController?
    
    lazy var context : NSManagedObjectContext = {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let persistenContainer = appDelegate.persistentContainer
        return persistenContainer.viewContext
    }()
    
   
    override func viewDidLoad() {
        super.viewDidLoad()
        authorNameTextField.becomeFirstResponder()
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    @IBAction func cancel(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }

}
