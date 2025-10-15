//
//  NotificationTasksViewController.swift
//  TSUserNotifications
//
//  Created by TAE SU LEE on 2021/06/25.
//

import TSUserNotifications
import UIKit

private enum Identifier {
    static let task1 = "Task1"
    static let task2 = "Task2"
    static let task3 = "Task3"
}

class NotificationTasksViewController: UIViewController {
    lazy var userNotifications1: [TSUserNotification] = {
        let today = Date()
        let calendar = Calendar.current
        let nextWeek = calendar.date(byAdding: .day, value: 7, to: today)!

        return [
            TSUserNotification(
                identifier: "\(Identifier.task1)_1",
                date: calendar.date(byAdding: .year, value: -5, to: today)!,
                repeatType: .none,
                title: "Past date - will be skipped"),
            TSUserNotification(
                identifier: "\(Identifier.task1)_2",
                date: nextWeek,
                repeatType: .none,
                title: "Next week - one time"),
            TSUserNotification(
                identifier: "\(Identifier.task1)_3",
                date: today,
                repeatType: .day,
                title: "Today time - repeat daily"),
            TSUserNotification(
                identifier: "\(Identifier.task1)_4",
                date: today,
                repeatType: .week,
                title: "Today time - repeat weekly"),
            TSUserNotification(
                identifier: "\(Identifier.task1)_5",
                date: today,
                repeatType: .month,
                title: "Today date - repeat monthly"),
            TSUserNotification(
                identifier: "\(Identifier.task1)_6",
                date: calendar.date(byAdding: .day, value: -1, to: today)!,
                repeatType: .month,
                title: "Yesterday date - repeat monthly"),
            TSUserNotification(
                identifier: "\(Identifier.task1)_7",
                date: today,
                repeatType: .year,
                title: "Today - repeat yearly"),
        ]
    }()

    lazy var userNotifications2: [TSUserNotification] = {
        let today = Date()
        let calendar = Calendar.current

        return [
            TSUserNotification(
                identifier: "\(Identifier.task2)_1",
                date: calendar.date(from: DateComponents(year: 2020, month: 2, day: 29))!,
                repeatType: .year,
                title: "Feb 29 (leap year) - repeat yearly")
        ]
    }()

    lazy var userNotifications3: [TSUserNotification] = {
        let today = Date()

        var userNotifications: [TSUserNotification] = []
        for index in 0..<64 {
            let notification = TSUserNotification(
                identifier: "\(Identifier.task3)_\(index)",
                date: today,
                repeatType: .day,
                title: "Today - repeat daily #\(index)")
            userNotifications.append(notification)
        }
        return userNotifications
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

// MARK: - IBAction
extension NotificationTasksViewController {
    @IBAction fileprivate func save(_ sender: Any) {
        let loadingIndicator = UIActivityIndicatorView(style: .large)
        loadingIndicator.center = view.center
        loadingIndicator.startAnimating()
        view.addSubview(loadingIndicator)
        view.isUserInteractionEnabled = false

        Task {
            await TSUserNotificationCenter.removeContain(identifier: Identifier.task1)
            TSUserNotificationCenter.set(notifications: userNotifications1, max: 64)

//            await TSUserNotificationCenter.removeContain(identifier: Identifier.task2)
//            TSUserNotificationCenter.set(notifications: userNotifications2, max: 10)

//            await TSUserNotificationCenter.removeContain(identifier: Identifier.task3)
//            TSUserNotificationCenter.set(notifications: userNotifications3, max: 64)

            await MainActor.run {
                loadingIndicator.stopAnimating()
                loadingIndicator.removeFromSuperview()
                view.isUserInteractionEnabled = true
                navigationController?.popViewController(animated: true)
            }
        }
    }
}
