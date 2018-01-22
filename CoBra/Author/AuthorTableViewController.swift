//
//  AuthorsTableViewController.swift
//  CoBra
//
//  Created by Juan José Hernández Alonso on 16/1/18.
//  Copyright © 2018 Universidad San Jorge. All rights reserved.
//

import UIKit
import CoreData

class AuthorTableViewController: UITableViewController {
    
    // Outlet
    @IBOutlet weak var addButtonItem: UIBarButtonItem!
    
    lazy var context : NSManagedObjectContext = {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let persistenContainer = appDelegate.persistentContainer
        return persistenContainer.viewContext
    }()
    
    lazy var frc : NSFetchedResultsController<Author> = {
        let req = NSFetchRequest<Author>(entityName:"Author")
        req.sortDescriptors = [ NSSortDescriptor(key:"surname", ascending:true)]
        let _frc = NSFetchedResultsController(fetchRequest: req,
                                              managedObjectContext: context,
                                              sectionNameKeyPath: nil,
                                              cacheName: nil)
        _frc.delegate = self
        try? _frc.performFetch()
        return _frc
    }()
    
    // Prepare view
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.rightBarButtonItems = [self.addButtonItem, self.editButtonItem]
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return frc.sections?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let section = frc.sections?[section] {
            return section.numberOfObjects
        }
        return 0
    }
    
    // Configure the cell for author
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var author : Author
        author = frc.object(at: indexPath)
        let cell = tableView.dequeueReusableCell(withIdentifier: "AuthorCell", for: indexPath) as! AuthorTableViewCell
        cell.author = author
        return cell
    }
    
    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let author = frc.object(at: indexPath)
            context.delete(author)
        }
    }

    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showAuthorDetail" {
            var author: Author
            if let row = tableView.indexPathForSelectedRow?.row {
                author = frc.object(at: IndexPath(row:row, section:0))
                let navigationViewController = segue.destination as! UINavigationController
                let detailViewController = navigationViewController.viewControllers.first as! AuthorDetailViewController
                detailViewController.author = author
            }
        }
    }
}

// MARK: - NSFetchedResultsControllerDelegate

extension AuthorTableViewController : NSFetchedResultsControllerDelegate {
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange sectionInfo: NSFetchedResultsSectionInfo, atSectionIndex sectionIndex: Int, for type: NSFetchedResultsChangeType) {
        
        switch type {
        case .delete:
            let indexSet = IndexSet(arrayLiteral: sectionIndex)
            tableView.deleteSections(indexSet, with: .fade)
        case .insert:
            let indexSet = IndexSet(arrayLiteral: sectionIndex)
            tableView.insertSections(indexSet, with: .fade)
        default:
            break
        }
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        
        switch type {
        case .delete:
            tableView.deleteRows(at: [indexPath!], with: .fade)
        case .insert:
            tableView.insertRows(at: [newIndexPath!], with: .fade)
        default:
            break
        }
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }
    
}




