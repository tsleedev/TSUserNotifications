//
//  NotificationWeekTableViewController.swift
//  TSUserNotifications
//
//  Created by TAE SU LEE on 2021/06/22.
//

import UIKit
import TSUserNotifications

class NotificationWeekTableViewController: UITableViewController {
    @IBOutlet private weak var datePicker: UIDatePicker!
    
    private var selectedWeeks: [TSUserNotificationDayOfTheWeek] = [.sunday, .monday, .tuesday, .wednesday, .thursday, .friday, .saturday]

    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

// MARK: - UITableViewDelegate
extension NotificationWeekTableViewController {
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let row = indexPath.row
        if row > 6 { return }
        
        tableView.deselectRow(at: indexPath, animated: true)
        guard let dayOfWeek = TSUserNotificationDayOfTheWeek(rawValue: indexPath.row + 1) else { return }
        let cell = tableView.cellForRow(at: indexPath)
        if let index = selectedWeeks.firstIndex(of: dayOfWeek) {
            selectedWeeks.remove(at: index)
            cell?.accessoryType = .none
        } else {
            selectedWeeks.append(dayOfWeek)
            cell?.accessoryType = .checkmark
        }
    }
}

// MARK: - IBAction
private extension NotificationWeekTableViewController {
    @IBAction func save(_ sender: Any) {
        navigationController?.popViewController(animated: true)
        let components = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: datePicker.date)
        guard let hour = components.hour, let minute = components.minute else { return }
        Task {
            await TSUserNotificationCenter.setDayOfTheWeek(
                identifier: "WEEK",
                hour: hour,
                minute: minute,
                dayOfTheWeeks: selectedWeeks,
                title: "weekly repeat test",
                subtitle: nil,
                body: "it's a test.",
                badge: nil,
                sound: nil,
                userInfo: nil,
                threadIdentifier: "WEEK"
            )
        }
    }
}
