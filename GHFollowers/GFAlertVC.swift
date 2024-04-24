//
//  GFAlertVC.swift
//  GHFollowers
//
//  Created by Maks Vogtman on 23/04/2024.
//

import UIKit

class GFAlertVC: UIViewController {
    let containerView = UIView()
    let titleLabel = GFTitleLabel(textAlignment: .center, fontSize: 20)
    let messageLabel = GFBodyLabel(textAlignment: .center)
    let actionButton = GFButton(backgroundColor: .systemPink, title: "Ok")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
}
