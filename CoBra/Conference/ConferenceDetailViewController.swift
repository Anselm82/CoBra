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
    @IBOutlet weak var websiteLabel: UILabel!
    @IBOutlet weak var rankingLabel: UILabel!
    @IBOutlet weak var articleDeadlineLabel: UILabel!
    @IBOutlet weak var abstractDeadlineLabel: UILabel!
    
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
        websiteLabel.text = conference?.website
        rankingLabel.text = conference?.ranking
        
        // Convert dates to strings
        let formatter = DateFormatter()
        formatter.dateFormat = "dd-MMM-yyyy hh:mm:ss"
        let abstractDate = formatter.string(from: (conference?.abstract_deadline)!)
        let articleDate = formatter.string(from: (conference?.article_deadline)!)
        abstractDeadlineLabel.text = abstractDate
        articleDeadlineLabel.text = articleDate
        
    }

}
