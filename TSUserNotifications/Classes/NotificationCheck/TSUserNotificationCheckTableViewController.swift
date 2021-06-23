//
//  TSUserNotificationCheckTableViewController.swift
//  TSFramework
//
//  Created by TAE SU LEE on 2021/06/22.
//

import UIKit
import UserNotifications

class TSUserNotificationCheckTableViewController: UITableViewController {
    private var notifications: [TSUserNotificationInfo] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
    }
}

// MARK: - UITableViewDataSource
extension TSUserNotificationCheckTableViewController {
    override func numberOfSections(in tableView: UITableView) -> Int {
        return notifications.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let notification = notifications[section]
        return notification.details.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NotificationCheckTableViewCell", for: indexPath) as! TSUserNotificationCheckTableViewCell
        
        let section = indexPath.section
        let row = indexPath.row
        
        let detail = notifications[section].details[row]
        cell.row = row
        cell.detail = detail
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let notification = notifications[section]
        return notification.threadIdentifier
    }
}

// MARK: - Help
private extension TSUserNotificationCheckTableViewController {
    func setup() {
        notifications.removeAll()
        
        UNUserNotificationCenter.current().getPendingNotificationRequests { [weak self] (requests) in
            guard let self = self else { return }
            for request in requests {
                if let trigger = request.trigger as? UNCalendarNotificationTrigger {
                    let dateComponents = trigger.dateComponents
                    let weekday = dateComponents.weekday
                    let isRepeat = trigger.repeats
                    var repeatDay: String?
                    if let weekday = weekday, isRepeat == true {
                        switch weekday {
                        case 1:
                            repeatDay = "매주 일요일"
                        case 2:
                            repeatDay = "매주 월요일"
                        case 3:
                            repeatDay = "매주 화요일"
                        case 4:
                            repeatDay = "매주 수요일"
                        case 5:
                            repeatDay = "매주 목요일"
                        case 6:
                            repeatDay = "매주 금요일"
                        case 7:
                            repeatDay = "매주 토요일"
                        default:
                            break
                        }
                    } else if isRepeat == true {
                        if dateComponents.day == nil {
                            repeatDay = "매일"
                        } else if dateComponents.month == nil {
                            repeatDay = "매주"
                        } else if dateComponents.year == nil {
                            repeatDay = "매월"
                        } else {
                            repeatDay = "매년"
                        }
                    }
                    self.setup(threadIdentifier: request.content.threadIdentifier,
                               fireDate: trigger.nextTriggerDate(),
                               alertTitle: request.content.title,
                               alertBody: request.content.body,
                               repeatDay: repeatDay)
                } else if let trigger = request.trigger as? UNTimeIntervalNotificationTrigger {
                    let repeatDay: String? = trigger.repeats ? "반복 \(trigger.timeInterval)" : nil
                    self.setup(threadIdentifier: request.content.threadIdentifier,
                               fireDate: trigger.nextTriggerDate(),
                               alertTitle: request.content.title,
                               alertBody: request.content.body,
                               repeatDay: repeatDay)
                }
            }
            
            DispatchQueue.main.async {
                self.setupTitle()
                self.tableView.reloadData()
            }
        }
    }
    
    func setupTitle() {
        title = "PendingNoti (\(notifications.count))"
    }
    
    func setup(threadIdentifier: String?, fireDate: Date?, alertTitle: String?, alertBody: String?, repeatDay: String?) {
        let notification: TSUserNotificationInfo
        if let tmp = notifications.filter({ return $0.threadIdentifier == threadIdentifier}).first {
            notification = tmp
        } else {
            notification = TSUserNotificationInfo()
            notifications.append(notification)
            if let threadIdentifier = threadIdentifier, !threadIdentifier.isEmpty {
                notification.threadIdentifier = threadIdentifier
            }
        }
        
        let detail = TSUserNotificationInfoDetail()
        if let fireDate = fireDate {
            detail.date = fireDate
        }
        if let alertTitle = alertTitle {
            detail.title = alertTitle
        }
        if let alertBody = alertBody {
            detail.message = alertBody
        }
        if let repeatDay = repeatDay {
            detail.repeatDay = repeatDay
        }
        
        notification.details.append(detail)
    }
}

// MARK: - IBAction
private extension TSUserNotificationCheckTableViewController {
    @IBAction func removeAll(_ sender: Any) {
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
        setup()
    }
}
