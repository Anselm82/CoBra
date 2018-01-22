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

    // Model
    var idea : Idea?
    var conference : Conference?
    lazy var authors : [Author] = {
        return [Author]()
    }()
    
    lazy var context : NSManagedObjectContext = {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let persistenContainer = appDelegate.persistentContainer
        return persistenContainer.viewContext
    }()
    
    var previous : IdeaTableViewController?
    
    // Frame for TextView Placeholder behaviour
    var frame : CGRect?
    // Bottom constraint initial value for keyboard animations
    var originalBottomSpace : CGFloat = 0.0
    
    // Outlets
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var ideaDescriptionTextView: UITextView!
    @IBOutlet weak var conferenceButton: UIBorderButton!
    @IBOutlet weak var authorsButton: UIButton!
    @IBOutlet weak var ideaTitleTextField: UITextField!
    
    @IBAction func cancel(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    // Make persistent
    @IBAction func save(_ sender: Any) {
        // Values are set
        guard authors.count > 0, conference != nil, ideaDescriptionTextView.text.count > 0, ideaTitleTextField.text?.count ?? 0 > 0, ideaDescriptionTextView.text != "Describe your idea here..." else {
            let alert = UIAlertController(title: "Create idea", message: "Please, complete all the fields.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
            self.present(alert, animated: false, completion: nil)            
            return
        }
        // Create entity, binding and perform persistence action
        idea = (NSEntityDescription.insertNewObject(forEntityName: "Idea", into: context) as! Idea)
        idea?.title = ideaTitleTextField.text
        idea?.idea_description = ideaDescriptionTextView.text
        idea?.conference = conference
        for author in authors {
            idea?.addToAuthors(author)
        }
        try? context.save()
        // Reload table data
        previous?.tableView.reloadData()
        dismiss(animated: true, completion: nil)
    }
    
    // Prepare view
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardAnimation(_:)), name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardAnimation(_:)), name: .UIKeyboardWillHide, object: nil)
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
        ideaDescriptionTextView.text = "Describe your idea here..."
        ideaDescriptionTextView.textColor = UIColor.lightGray
        ideaDescriptionTextView.delegate = self
        frame = ideaDescriptionTextView.frame
        ideaDescriptionTextView.isScrollEnabled = false
        view.addGestureRecognizer(tap)
        ideaTitleTextField.becomeFirstResponder()
    }
    
    // On touch outside dismiss keyboard
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    // Modify constraint on keyboard animation
    @objc func keyboardAnimation(_ notification: Notification) {
        let userInfo = notification.userInfo!
        let animationDuration = (userInfo[UIKeyboardAnimationDurationUserInfoKey] as! NSNumber).doubleValue
        let keyboardEndFrame = (userInfo[UIKeyboardFrameEndUserInfoKey] as! CGRect)
        let convertedKeyboardEndFrame = view.convert(keyboardEndFrame, from: view.window)
        let curve = userInfo[UIKeyboardAnimationCurveUserInfoKey] as! NSNumber
        let animationCurve = UIViewAnimationOptions(rawValue:curve.uintValue << 16)
        let height = view.bounds.size.height - convertedKeyboardEndFrame.origin.y
        bottomConstraint.constant = originalBottomSpace + height
        UIView.animate(withDuration: animationDuration,
                       delay: 0.0,
                       options: [.beginFromCurrentState, animationCurve],
                       animations: {
                        self.view.layoutIfNeeded()
        }, completion: nil)
    }
    
    // Configure buttons text after selection
    override func viewWillAppear(_ animated: Bool) {
        var text = "Authors"
        if authors.count > 0 {
            if authors.count >= 1 {
                text = "\(authors.first!.surname ?? ""), \(authors.first!.name ?? "")"
            }
            if authors.count == 2 {
                text += " & \(authors.last!.surname ?? ""), \(authors.last!.name ?? "")"
            }
            if authors.count > 2 {
                text += " et al."
            }
        }
        authorsButton.setTitle(text, for: .normal)
        var ctext = "Conference"
        if conference != nil {
            ctext = conference!.acronym!
        }
        conferenceButton.setTitle(ctext, for: .normal)
    }
    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "selectAuthor" {
            let navigationController = segue.destination as! UINavigationController
            let ideaAuthorTableViewController = navigationController.viewControllers.first as! IdeaAuthorTableViewController
            ideaAuthorTableViewController.previous = self
        } else if segue.identifier == "selectConference" {
            let navigationController = segue.destination as! UINavigationController
            let ideaConferenceTableViewController = navigationController.viewControllers.first as! IdeaConferenceTableViewController
            ideaConferenceTableViewController.previous = self
        }
    }
}

// MARK: - TextView PlaceHolder behaviour

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
