//
//  ViewExtensions.swift
//  To-Do List
//
//  Created by Sooraj R on 19/10/24.
//

import UIKit

extension UIView{

   func setCornerRadius(radius: CGFloat) {
      self.layer.cornerRadius = radius
   }
   func setBackgroundColor(color: UIColor) {
      self.backgroundColor = color
   }
   func setBoarder(color: UIColor,width: CGFloat) {
      self.layer.borderWidth = width
      self.layer.borderColor = color.cgColor
   }
   func setShadow(radius: CGFloat = 5,opacity: Float = 0.5,color: UIColor = UIColor.lightGray,offset: CGSize = CGSize.zero) {
      self.layer.shadowRadius = radius
      self.layer.shadowOpacity = opacity
      self.layer.shadowOffset = offset
      self.layer.shadowColor = color.cgColor
   }
}
