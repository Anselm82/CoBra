//
//  IdeaAuthorTableViewController.swift
//  CoBra
//
//  Created by Juan José Hernández Alonso on 18/1/18.
//  Copyright © 2018 Universidad San Jorge. All rights reserved.
//

import UIKit
import CoreData

class IdeaAuthorTableViewController: UITableViewController {

    var previous : IdeaAddViewController?
    lazy var authors : [Author] = {
       return [Author]()
    }()
    
    lazy var context : NSManagedObjectContext = {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let persistenContainer = appDelegate.persistentContainer
        return persistenContainer.viewContext
    }()
    
    lazy var frc : NSFetchedResultsController<Author> = {
        let req = NSFetchRequest<Author>(entityName:"Author")
        req.sortDescriptors = [ NSSortDescriptor(key:"name", ascending:true)]
        let _frc = NSFetchedResultsController(fetchRequest: req,
                                              managedObjectContext: context,
                                              sectionNameKeyPath: nil,
                                              cacheName: nil)
        _frc.delegate = self
        try? _frc.performFetch()
        return _frc
    }()
    
    // Authors selected
    @IBAction func selectionFinished(_ sender: Any) {
        previous?.authors = authors
        dismiss(animated: true, completion: nil)
    }
    
    // Prepare view
    override func viewDidLoad() {
        super.viewDidLoad()
        clearsSelectionOnViewWillAppear = false
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
    
    // Prepare cell for author
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let author = frc.object(at: indexPath)
        let cell = tableView.dequeueReusableCell(withIdentifier: "IdeaAuthorSelectionCell", for: indexPath) as! AuthorTableViewCell
        cell.author = author
        return cell
    }
    
    // MARK: - Selection handling
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var author : Author
        author = frc.object(at: indexPath)
        // Send author to previous controller
        let cell = tableView.cellForRow(at: indexPath)
        cell?.isSelected = true
        if !authors.contains(author) {
            authors.append(author)
        }
    }
    
    override func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        var author : Author
        author = frc.object(at: indexPath)
        // Remove author from previous controller
        let cell = tableView.cellForRow(at: indexPath)
        cell?.isSelected = false
        if authors.contains(author) {
            authors.remove(at: authors.index(of: author)!)
        }
    }

}

// MARK: - NSFetchedResultsControllerDelegate

extension IdeaAuthorTableViewController : NSFetchedResultsControllerDelegate {

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

