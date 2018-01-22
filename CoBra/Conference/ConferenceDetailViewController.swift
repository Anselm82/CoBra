//
//  ConferenceDetailViewController.swift
//  CoBra
//
//  Created by Juan José Hernández Alonso on 17/1/18.
//  Copyright © 2018 Universidad San Jorge. All rights reserved.
//

import UIKit

class ConferenceDetailViewController: UIViewController {
    
    // Outlets
    @IBOutlet weak var conferenceNameLabel: UILabel!
    @IBOutlet weak var acronymLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var rankingLabel: UILabel!
    @IBOutlet weak var articleDeadlineLabel: UILabel!
    @IBOutlet weak var abstractDeadlineLabel: UILabel!
    @IBOutlet weak var websiteTextView: UITextView!
    
    var conference : Conference?

    @IBAction func close(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    // Prepare view
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard conference != nil else {
            return
        }
        
        conferenceNameLabel.text = conference?.name
        acronymLabel.text = conference?.acronym
        addressLabel.text = conference?.location
        rankingLabel.text = conference?.ranking
        
        let linkAttributes = [
            NSAttributedStringKey.link: URL(string: (conference?.website)!)!,
            NSAttributedStringKey.font: UIFont(name: "Helvetica", size: 18.0)!,
            NSAttributedStringKey.foregroundColor: UIColor.blue
            ] as [NSAttributedStringKey : Any]
        
        let attributedString = NSMutableAttributedString(string: (conference?.website)!)
        attributedString.setAttributes(linkAttributes, range: NSMakeRange(0, attributedString.length))
        websiteTextView.attributedText = attributedString
        
        
        // Convert dates to strings
        let formatter = DateFormatter()
        formatter.dateFormat = "dd-MMM-yyyy hh:mm:ss"
        let abstractDate = formatter.string(from: (conference?.abstract_deadline)!)
        let articleDate = formatter.string(from: (conference?.article_deadline)!)
        abstractDeadlineLabel.text = abstractDate
        articleDeadlineLabel.text = articleDate
        
    }

}
