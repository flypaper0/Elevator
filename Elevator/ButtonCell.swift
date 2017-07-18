//
//  ButtonCell.swift
//  Elevator
//
//  Created by Artur Guseinov on 13/07/2017.
//  Copyright © 2017 Artur Guseinov. All rights reserved.
//

import UIKit

class ButtonCell: UICollectionViewCell {
    
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var buttonBackgroundView: UIView!
    
    override var isHighlighted: Bool {
        didSet {
            buttonBackgroundView.alpha = isHighlighted ? 0.5 : 1
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        buttonBackgroundView.layer.cornerRadius = 10
        buttonBackgroundView.layer.masksToBounds = true
    }
    
}
