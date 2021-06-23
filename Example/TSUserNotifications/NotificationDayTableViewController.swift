//
//  NotificationDayTableViewController.swift
//  TSUserNotifications
//
//  Created by TAE SU LEE on 2021/06/22.
//

import UIKit
import TSUserNotifications

class NotificationDayTableViewController: UITableViewController {
    @IBOutlet private weak var datePicker: UIDatePicker!

    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

// MARK: - IBAction
private extension NotificationDayTableViewController {
    @IBAction func save(_ sender: Any) {
        navigationController?.popViewController(animated: true)
        TSUserNotificationCenter.set(identifier: "DAY",
                                     date: datePicker.date,
                                     repeatType: .none,
                                     title: "알림 테스트",
                                     subtitle: nil,
                                     body: "테스트입니다.",
                                     badge: nil,
                                     sound: nil,
                                     userInfo: nil,
                                     threadIdentifier: "DAY")
//        let components = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: datePicker.date)
//        guard let hour = components.hour, let miniute = components.minute else { return }
//        TSUserNotificationCenter.set(identifier: "DAY",
//                                     year: components.year,
//                                     month: components.month,
//                                     hour: hour,
//                                     miniute: miniute,
//                                     repeatType: .none,
//                                     title: "알림 테스트",
//                                     subtitle: nil,
//                                     body: "테스트입니다.",
//                                     badge: nil,
//                                     sound: nil,
//                                     userInfo: nil,
//                                     threadIdentifier: "DAY")
    }
}
