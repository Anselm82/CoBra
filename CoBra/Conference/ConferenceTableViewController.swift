//
//  ConferenceTableViewController.swift
//
//  Created by Lapeña Martí Raúl on 18/01/2018.
//  Copyright © 2018 Universidad San Jorge. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class ConferenceTableViewController: UITableViewController {
    
    lazy var filteredConferences : [Conference]? = {
        return [Conference]()
    }()
    
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
        
        _frc.delegate = self as? NSFetchedResultsControllerDelegate
        
        try? _frc.performFetch()
        
        return _frc
        
    }()
    
    //var backgroundTask : UIBackgroundTaskIdentifier = 0
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        let searchController = UISearchController(searchResultsController: nil)
        searchController.delegate = self
        navigationItem.searchController = searchController
        
        // Setup the Search Controller
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search Conferences"
        definesPresentationContext = true
        
        self.downloadConferencesList(nil)
        
        
        
        weak var weakSelf = self
        
        NotificationCenter.default.addObserver(forName: Notification.Name.UIApplicationDidBecomeActive,
                                               object: nil,
                                               queue: .main) { (notification) in
                                                
                                                weakSelf?.downloadConferencesList(nil)
        }
        
        NotificationCenter.default.addObserver(forName: .UIApplicationWillTerminate ,
                                               object: nil,
                                               queue: .main) { (notification) in
                                                
                                                
                                                
        }
        
        tableView.refreshControl = UIRefreshControl()
        tableView.refreshControl!.addTarget(self,
                                            action: #selector(refreshControlAction(_:)),
                                            for: .valueChanged)
    }
    
    
    @objc func refreshControlAction(_ sender : UIRefreshControl) {
        downloadConferencesList(sender)
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
        
        if navigationItem.searchController!.isActive ,
            !textIsEmpty(navigationItem.searchController!.searchBar.text)  {
            return filteredConferences!.count
        } else {
            if let section = frc.sections?[section] {
                return section.numberOfObjects
            }
            return 0
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var conference : Conference
        
        if navigationItem.searchController!.isActive ,
            !textIsEmpty(navigationItem.searchController!.searchBar.text) {
            conference = filteredConferences![indexPath.row]
        } else {
            conference = frc.object(at: indexPath)
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ConferenceCell", for: indexPath) as! ConferenceTableViewCell
        
        cell.conferenceNameLabel.text = conference.acronym
        
        return cell
    }
      
    
    // MARK: - Navigation
    
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        
        if identifier == "showConferenceDetail" ,
            let _ = tableView.indexPathForSelectedRow?.row {
            return true
        } else {
            return false
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showConferenceDetail" {
            
            var conference: Conference
            
            if let row = tableView.indexPathForSelectedRow?.row {
                
                if navigationItem.searchController!.isActive,
                    navigationItem.searchController!.searchBar.text?.count ?? 0 > 0 {
                    conference = filteredConferences![row]
                } else {
                    conference = frc.object(at: IndexPath(row:row, section:0))
                }
                
                let nav = segue.destination as! UINavigationController
                
                let nextVC = nav.viewControllers.first as! ConferenceDetailViewController
                
                nextVC.conference = conference
                
            }
        }
    }
    
    @IBAction func backToMenu(_ segue:UIStoryboardSegue) {
        
    }
}

extension ConferenceTableViewController {
    
    @objc func downloadConferencesList(_ control :UIRefreshControl?) {
        
        let session = URLSession.shared
        
        let url = URL(string: conferencesURL)!
        
        let request = URLRequest(url: url,
                                 cachePolicy: .reloadIgnoringLocalAndRemoteCacheData,
                                 timeoutInterval: 15.0)
        
        weak var weakSelf = self
        
        let task = session.dataTask(with: request) { (data, response, error) in
            
            
            guard error == nil || data?.count ?? 0 > 0  else {
                
                DispatchQueue.main.async {
                    control?.endRefreshing()
                }
                
                return
            }
            
            DispatchQueue.main.async {
                if let conferences = try? (PropertyListSerialization.propertyList(from: data!,
                                                                                options: .mutableContainers,
                                                                                format: nil) as! [[String:Any]]) {
                    weakSelf?.saveConferences(conferences)
                }
                
                control?.endRefreshing()
                
            }
        }
        task.resume()
    }
    
    func saveConferences(_ conferences: [[String:Any]]) {
        let sortConferences = conferences.sorted { (objA, objB) -> Bool in
            if let firstAcronym = objA["acronym"] as? String,
                let secondAcronym = objB["acronym"] as? String {
                return firstAcronym < secondAcronym
            } else {
                return false
            }
        }
        
        let req = NSFetchRequest<Conference>(entityName: "Conference")
        req.sortDescriptors = [ NSSortDescriptor(key:"acronym", ascending:true)]
        let results = try? context.fetch(req)
        
        var indexNew : Int = 0
        var indexOld : Int = 0
        
        while indexNew < sortConferences.count &&
            indexOld < (results?.count ?? 0) {
                
                let newObj = sortConferences[indexNew]
                let oldObj = results![indexOld]
                
                if let newAcronym = newObj["acronym"] as? String , let oldAcronym = oldObj.acronym {
                    
                    if newAcronym == oldAcronym {
                        
                        oldObj.abstract_deadline = newObj["abstract_deadline"] as? Date
                        oldObj.article_deadline = newObj["article_deadline"] as? Date
                        oldObj.name = newObj["name"] as? String
                        oldObj.acronym = newObj["acronym"] as? String
                        oldObj.location = newObj["location"] as? String
                        oldObj.ranking = newObj["ranking"] as? String
                        oldObj.website = newObj["website"] as? String

                        
                        indexNew += 1
                        indexOld += 1
                        
                    } else if newAcronym < oldAcronym {
                        let conference = NSEntityDescription.insertNewObject(forEntityName: "Conference",
                                                                          into: context) as! Conference
                        
                        conference.abstract_deadline = newObj["abstract_deadline"] as? Date
                        conference.article_deadline = newObj["article_deadline"] as? Date
                        conference.name = newObj["name"] as? String
                        conference.acronym = newObj["acronym"] as? String
                        conference.location = newObj["location"] as? String
                        conference.ranking = newObj["ranking"] as? String
                        conference.website = newObj["website"] as? String
                        
                        indexNew += 1
                        
                    } else {
                        
                        context.delete(oldObj)
                        indexOld += 1
                        
                    }
                }
        }
        
        while indexNew < sortConferences.count {
            
            let newObj = sortConferences[indexNew]
            let conference = NSEntityDescription.insertNewObject(forEntityName: "Conference",
                                                              into: context) as! Conference
           
            conference.abstract_deadline = newObj["abstract_deadline"] as? Date
            conference.article_deadline = newObj["article_deadline"] as? Date
            conference.name = newObj["name"] as? String
            conference.acronym = newObj["acronym"] as? String
            conference.location = newObj["location"] as? String
            conference.ranking = newObj["ranking"] as? String
            conference.website = newObj["website"] as? String
            
            indexNew += 1
        }
        
        while indexOld < results?.count ?? 0 {
            
            let oldObj = results![indexOld]
            context.delete(oldObj)
            
            indexOld += 1
        }
        
        try? context.save()
    }
}

extension ConferenceTableViewController : UISearchControllerDelegate, UISearchResultsUpdating {
    
    func textIsEmpty( _ text: String?) -> Bool {
        return (text?.count ?? 0) == 0
    }
    
    func filterContentForSearchText(_ searchText: String, scope: String = "All") {
        
        let req = NSFetchRequest<Conference>(entityName:"Conference")
        
        req.predicate = NSPredicate(format:"acronym CONTAINS[cd] %@", searchText)
        
        req.sortDescriptors = [ NSSortDescriptor(key:"acronym", ascending:true)]
        if let results = try? context.fetch(req) {
            filteredConferences = results
        } else {
            filteredConferences = [Conference]()
        }
        
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        
        let searchText = searchController.searchBar.text
        
        if textIsEmpty(searchText) {
            
            filteredConferences = [Conference]()
            
        } else {
            
            filterContentForSearchText(searchText!)
            
        }
        
        tableView.reloadData()
    }
}
