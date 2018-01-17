//
//  DetailViewController.swift
//  CoBra
//
//  Created by Juan José Hernández Alonso on 15/1/18.
//  Copyright © 2018 Universidad San Jorge. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

    @IBOutlet weak var detailDescriptionLabel: UILabel!


    func configureView() {
        // Update the user interface for the detail item.
        if detailItem != nil {
            if let label = detailDescriptionLabel {
                label.text = detailItem?.name
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        configureView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    var detailItem: Author? {
        didSet {
            // Update the view.
            configureView()
        }
    }


}

