//
//  IdeaConferenceTableViewController.swift
//  CoBra
//
//  Created by Juan José Hernández Alonso on 18/1/18.
//  Copyright © 2018 Universidad San Jorge. All rights reserved.
//

import UIKit
import CoreData

class IdeaConferenceTableViewController: UITableViewController {

    var previous : IdeaAddViewController?
    
    lazy var context : NSManagedObjectContext = {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let persistenContainer = appDelegate.persistentContainer
        return persistenContainer.viewContext
    }()
    
    lazy var frc : NSFetchedResultsController<Conference> = {
        let req = NSFetchRequest<Conference>(entityName:"Conference")
        req.sortDescriptors = [ NSSortDescriptor(key:"acronym", ascending:true)]
        let _frc = NSFetchedResultsController(fetchRequest: req,
                                              managedObjectContext: context,
                                              sectionNameKeyPath: nil,
                                              cacheName: nil)
        _frc.delegate = self
        try? _frc.performFetch()
        return _frc
    }()
    
    // Can be moved to didSelectRowAt
    @IBAction func selectionFinished(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    // Prepare view
    override func viewDidLoad() {
        super.viewDidLoad()
        self.clearsSelectionOnViewWillAppear = false
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
    
    // Prepare cell for conference
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let conference = frc.object(at: indexPath)
        let cell = tableView.dequeueReusableCell(withIdentifier: "IdeaConferenceSelectionCell", for: indexPath) as! ConferenceTableViewCell
        cell.conference = conference
        return cell
    }
    
    // MARK: - Selection
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var conference : Conference
        conference = frc.object(at: indexPath)
        previous!.conference = conference
    }
    
    override func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        var conference : Conference
        conference = frc.object(at: indexPath)
        if previous!.conference == conference {
            previous!.conference = nil
        }
    }
}

// MARK : - NSFetchedResultsControllerDelegate
extension IdeaConferenceTableViewController : NSFetchedResultsControllerDelegate {
    
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
