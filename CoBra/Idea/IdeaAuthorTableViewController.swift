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
    
    @IBAction func selectionFinished(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let author = frc.object(at: indexPath)
        let cell = tableView.dequeueReusableCell(withIdentifier: "IdeaDetailCell", for: indexPath) as! AuthorTableViewCell
        cell.author = author
        let name = author.name!
        let surname = author.surname!
        cell.authorNameLabel.text = "\(surname), \(name)"
        
        return cell
    }
    
    // MARK: - Selection
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let author = frc.object(at: indexPath)
        if previous!.authors.contains(author) {
            cell.isSelected = true
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var author : Author
        author = frc.object(at: indexPath)
        previous!.authors.append(author)
    }
    
    override func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        var author : Author
        author = frc.object(at: indexPath)
        if previous!.authors.contains(author) {
            let index = previous!.authors.index(of: author)!
            previous!.authors.remove(at: index)
        }
    }
    

    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

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
