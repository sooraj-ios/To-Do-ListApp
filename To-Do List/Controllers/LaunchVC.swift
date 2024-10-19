//
//  LaunchVC.swift
//  To-Do List
//
//  Created by Sooraj R on 19/10/24.
//

import UIKit

class LaunchVC: UIViewController {

    // MARK: - LOADING VIEW CONTROLLER
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: {
            let nextVC = AppController.shared.toDoList
            self.navigationController?.pushViewController(nextVC, animated: true)
        })
    }
}

