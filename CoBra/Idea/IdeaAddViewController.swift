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
    var authors = [Author]()
    
    @IBOutlet weak var ideaDescriptionTextView: UITextView!
    
    @IBOutlet weak var authorsButton: UIButton!
    
    @IBAction func cancel(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    lazy var context : NSManagedObjectContext = {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let persistenContainer = appDelegate.persistentContainer
        return persistenContainer.viewContext
    }()
    
    var frame : CGRect?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //navigationItem.leftItemsSupplementBackButton = true
        //navigationItem.leftBarButtonItem = cancelButton
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        idea = (NSEntityDescription.insertNewObject(forEntityName: "Idea", into: context) as! Idea)
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
        ideaDescriptionTextView.text = "Describe your idea here..."
        ideaDescriptionTextView.textColor = UIColor.lightGray
        ideaDescriptionTextView.delegate = self
        frame = ideaDescriptionTextView.frame
        ideaDescriptionTextView.isScrollEnabled = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        ideaDescriptionTextView.translatesAutoresizingMaskIntoConstraints = true
        ideaDescriptionTextView.sizeToFit()
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        ideaDescriptionTextView.translatesAutoresizingMaskIntoConstraints = true
        ideaDescriptionTextView.sizeToFit()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        var text = "Authors"
        if authors.count >= 1 {
            text = "\(authors.first!.surname ?? ""), \(authors.first!.name ?? "")"
        }
        if authors.count == 2 {
            text += " & \(authors.last!.surname ?? ""), \(authors.last!.name ?? "")"
        }
        if authors.count > 2 {
            text += " et al."
        }
        authorsButton.setTitle(text, for: .normal)
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "selectAuthor" {
            let navigationController = segue.destination as! UINavigationController
            let ideaAuthorTableViewController = navigationController.viewControllers.first as! IdeaAuthorTableViewController
            ideaAuthorTableViewController.previous = self
        }
    }
}

extension IdeaAddViewController : UITextViewDelegate {
    
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if ideaDescriptionTextView.textColor == UIColor.lightGray {
            ideaDescriptionTextView.text = nil
            ideaDescriptionTextView.textColor = UIColor.black
        }
        ideaDescriptionTextView.frame = frame!
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "Describe your idea here..."
            textView.textColor = UIColor.lightGray
        }
        ideaDescriptionTextView.frame = frame!
    }
}
