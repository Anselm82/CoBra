//
//  UIBorderButton.swift
//  CoBra
//
//  Created by Juan José Hernández Alonso on 18/1/18.
//  Copyright © 2018 Universidad San Jorge. All rights reserved.
//

import UIKit

class UIBorderButton: UIButton {

    override func draw(_ rect: CGRect) {
        self.backgroundColor = .clear
        self.layer.cornerRadius = 5
        self.layer.borderWidth = 1
        self.layer.borderColor = #colorLiteral(red: 0, green: 0.5898008943, blue: 1, alpha: 1)
        self.titleEdgeInsets = UIEdgeInsetsMake(5, 5, 5, 5)
    }
}
