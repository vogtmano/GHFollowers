//
//  UIHelper.swift
//  GHFollowers
//
//  Created by Maks Vogtman on 28/05/2024.
//

import UIKit


// I've placed this function in the UIHelper struct, couse my view controller (FollowerListVC) didn't have to know about it.
struct UIHelper {
    
// The function is static, so I can access it like that: UIHelper.createThree...()
    static func createThreeColumnFlowLayout(in view: UIView) -> UICollectionViewFlowLayout {
        let width = view.bounds.width
        let padding: CGFloat = 12
        let minimumItemSpacing: CGFloat = 10
        let availableWidth = width - (padding * 2) - (minimumItemSpacing * 2)
        let itemWidth = availableWidth / 3
        
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.sectionInset = UIEdgeInsets(top: padding, left: padding, bottom: padding, right: padding)
        flowLayout.itemSize = CGSize(width: itemWidth, height: itemWidth + 40)
        
        return flowLayout
    }
}
