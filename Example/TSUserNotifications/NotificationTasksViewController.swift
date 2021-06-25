//
//  NotificationTasksViewController.swift
//  TSUserNotifications
//
//  Created by TAE SU LEE on 2021/06/25.
//

import UIKit
import TSUserNotifications

private enum Identifier {
    static let task = "Task"
}

class NotificationTasksViewController: UIViewController {
    let usernofitications = [
        TSUserNofitication(identifier: "\(Identifier.task)1",
                           date: "2020-01-01".date!,
                           repeatType: .none,
                           title: "2020-01-01 none"),
        TSUserNofitication(identifier: "\(Identifier.task)2",
                           date: "2025-12-24".date!,
                           repeatType: .none,
                           title: "2025-12-24 none"),
        TSUserNofitication(identifier: "\(Identifier.task)3",
                           date: "2021-01-01".date!,
                           repeatType: .day,
                           title: "2021-01-01 day"),
        TSUserNofitication(identifier: "\(Identifier.task)4",
                           date: "2021-01-01".date!,
                           repeatType: .week,
                           title: "2020-01-01(Fri) week"),
        TSUserNofitication(identifier: "\(Identifier.task)5",
                           date: "2021-01-01".date!,
                           repeatType: .month,
                           title: "2020-01-01 month"),
        TSUserNofitication(identifier: "\(Identifier.task)6",
                           date: "2021-01-31".date!,
                           repeatType: .month,
                           title: "2020-01-31 month"),
        TSUserNofitication(identifier: "\(Identifier.task)7",
                           date: "2021-01-01".date!,
                           repeatType: .year,
                           title: "2020-01-01 year")
    ]

    override func viewDidLoad() {
        super.viewDidLoad()

    }
}

// MARK: - IBAction
private extension NotificationTasksViewController {
    @IBAction func save(_ sender: Any) {
        navigationController?.popViewController(animated: true)
        TSUserNotificationCenter.removeContain(identifier: Identifier.task)
        TSUserNotificationCenter.set(nofitications: usernofitications, max: 5)
    }
}

