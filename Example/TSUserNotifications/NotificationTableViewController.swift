//
//  NotificationTableViewController.swift
//  TSUserNotifications_Example
//
//  Created by TAE SU LEE on 2023/09/08.
//  Copyright © 2023 CocoaPods. All rights reserved.
//

import UIKit
import TSUserNotifications

class NotificationTableViewController: UITableViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

// MARK: - IBAction
private extension NotificationTableViewController {
    @IBAction func pending(_ sender: Any) {
        let viewController = TSUserNotificationCheckViewController()
        self.navigationController?.pushViewController(viewController, animated: true)
    }
}
