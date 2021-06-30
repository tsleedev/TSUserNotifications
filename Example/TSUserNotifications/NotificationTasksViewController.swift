//
//  NotificationTasksViewController.swift
//  TSUserNotifications
//
//  Created by TAE SU LEE on 2021/06/25.
//

import UIKit
import TSUserNotifications

private enum Identifier {
    static let task1 = "Task1"
    static let task2 = "Task2"
    static let task3 = "Task3"
}

class NotificationTasksViewController: UIViewController {
    let userNotifications1 = [
        TSUserNotification(identifier: "\(Identifier.task1)_1",
                           date: "2020-01-01".date!,
                           repeatType: .none,
                           title: "2020-01-01 none"),
        TSUserNotification(identifier: "\(Identifier.task1)_2",
                           date: "2025-12-24".date!,
                           repeatType: .none,
                           title: "2025-12-24 none"),
        TSUserNotification(identifier: "\(Identifier.task1)_3",
                           date: "2021-01-01".date!,
                           repeatType: .day,
                           title: "2021-01-01 day"),
        TSUserNotification(identifier: "\(Identifier.task1)_4",
                           date: "2021-01-01".date!,
                           repeatType: .week,
                           title: "2021-01-01(Fri) week"),
        TSUserNotification(identifier: "\(Identifier.task1)_5",
                           date: "2021-01-01".date!,
                           repeatType: .month,
                           title: "2021-01-01 month"),
        TSUserNotification(identifier: "\(Identifier.task1)_6",
                           date: "2021-01-31".date!,
                           repeatType: .month,
                           title: "2021-01-31 month"),
        TSUserNotification(identifier: "\(Identifier.task1)_7",
                           date: "2021-01-01".date!,
                           repeatType: .year,
                           title: "2021-01-01 year")
    ]
    
    let userNotifications2 = [
//        TSUserNotification(identifier: "\(Identifier.task2)_1",
//                           date: "2021-01-01".date!,
//                           repeatType: .day,
//                           title: "2021-01-01 day"),
//        TSUserNotification(identifier: "\(Identifier.task2)_2",
//                           date: "2021-01-01".date!,
//                           repeatType: .week,
//                           title: "2021-01-01(Fri) week"),
//        TSUserNotification(identifier: "\(Identifier.task2)_3",
//                           date: "2021-01-01".date!,
//                           repeatType: .month,
//                           title: "2021-01-01 month"),
//        TSUserNotification(identifier: "\(Identifier.task2)_4",
//                           date: "2021-01-31".date!,
//                           repeatType: .month,
//                           title: "2021-01-31 month"),
//        TSUserNotification(identifier: "\(Identifier.task2)_5",
//                           date: "2021-01-01".date!,
//                           repeatType: .year,
//                           title: "2021-01-01 year"),
        TSUserNotification(identifier: "\(Identifier.task2)_6",
                           date: "2020-02-29".date!,
                           repeatType: .year,
                           title: "2020-02-29 year")
    ]
    
    var userNotifications3: [TSUserNotification] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        for index in 0..<64 {
            let notification = TSUserNotification(identifier: "\(Identifier.task3)_\(index)",
                                                  date: "2021-01-01".date!,
                                                  repeatType: .day,
                                                  title: "2021-01-01 date")
            userNotifications3.append(notification)
        }
    }
}

// MARK: - IBAction
private extension NotificationTasksViewController {
    @IBAction func save(_ sender: Any) {
        navigationController?.popViewController(animated: true)
        
        TSUserNotificationCenter.removeContain(identifier: Identifier.task1) { [weak self] in
            guard let self = self else { return }
            TSUserNotificationCenter.set(notifications: self.userNotifications1, max: 5)
        }
        
        TSUserNotificationCenter.removeContain(identifier: Identifier.task2) { [weak self] in
            guard let self = self else { return }
            TSUserNotificationCenter.set(notifications: self.userNotifications2, max: 10)
        }
        
        TSUserNotificationCenter.removeContain(identifier: Identifier.task3) { [weak self] in
            guard let self = self else { return }
            TSUserNotificationCenter.set(notifications: self.userNotifications3, max: 64)
        }
    }
}

