//
//  CollectionViewExtensions.swift
//  To-Do List
//
//  Created by Sooraj R on 19/10/24.
//

import UIKit

extension UICollectionViewCell {

    static func register(for collectionView: UICollectionView)  {
        let cellName = String(describing: self)
        let cellIdentifier = cellName + "_id"
        let cellNib = UINib(nibName: String(describing: self), bundle: nil)
        collectionView.register(cellNib, forCellWithReuseIdentifier: cellIdentifier)
    }
}
