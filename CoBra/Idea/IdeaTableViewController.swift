//
//  IdeaTableViewController.swift
//  CoBra
//
//  Created by Juan José Hernández Alonso on 17/1/18.
//  Copyright © 2018 Universidad San Jorge. All rights reserved.
//

import UIKit
import CoreData

class IdeaTableViewController: UITableViewController {
    
    // Outlets
    @IBOutlet weak var addButtonItem: UIBarButtonItem!
    
    var idea: Idea?
    
    // Prepare view
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.rightBarButtonItems = [self.addButtonItem, self.editButtonItem]
    }
    
    lazy var context : NSManagedObjectContext = {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let persistenContainer = appDelegate.persistentContainer
        return persistenContainer.viewContext
    }()
    
    lazy var frc : NSFetchedResultsController<Idea> = {
        let req = NSFetchRequest<Idea>(entityName:"Idea")
        req.sortDescriptors = [ NSSortDescriptor(key:"title", ascending:true)]
        let _frc = NSFetchedResultsController(fetchRequest: req,
                                              managedObjectContext: context,
                                              sectionNameKeyPath: nil,
                                              cacheName: nil)
        _frc.delegate = self
        try? _frc.performFetch()
        return _frc
    }()
    
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

    // Prepare cell for idea
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var idea : Idea
        idea = frc.object(at: indexPath)
        let cell = tableView.dequeueReusableCell(withIdentifier: "IdeaCell", for: indexPath) as! IdeaTableViewCell
        cell.idea = idea
        return cell
    }
    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let idea = frc.object(at: indexPath)
            context.delete(idea)
        }
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showIdeaDetail" {
            var idea: Idea
            if let row = tableView.indexPathForSelectedRow?.row {
                idea = frc.object(at: IndexPath(row:row, section:0))
                let nextVC = segue.destination as! UINavigationController
                let detail = nextVC.viewControllers.first as! IdeaDetailViewController
                detail.idea = idea
            }
        } else if segue.identifier == "addIdea" {
            let nextVC = segue.destination as! UINavigationController
            let add = nextVC.viewControllers.first as! IdeaAddViewController
            add.previous = self
        }
    }
 

}

// MARK: - AuthorTableViewController+NSFetchedResultsControllerDelegate

extension IdeaTableViewController : NSFetchedResultsControllerDelegate {
    
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
        case .move:
            tableView.moveRow(at: indexPath!, to: newIndexPath!)
        case .update:
            tableView.reloadRows(at: [indexPath!], with: .fade)
        }
        
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }
    
}
