//
//  ButtonClasses.swift
//  To-Do List
//
//  Created by Sooraj R on 19/10/24.
//

import UIKit
class RoundedButton: UIButton {

    override func awakeFromNib() {
        super.awakeFromNib()
        self.clipsToBounds = true
        self.setCornerRadius(radius: self.frame.height/2)
    }
}
