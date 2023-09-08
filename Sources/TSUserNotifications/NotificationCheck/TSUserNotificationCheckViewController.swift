//
//  TSUserNotificationCheckViewController.swift
//  
//
//  Created by TAE SU LEE on 2023/09/07.
//

import UIKit
import UserNotifications

public class TSUserNotificationCheckViewController: UIViewController {
    @IBOutlet private var tableView: UITableView!
    private var notifications: [TSUserNotificationInfo] = []
    
    public init() {
        super.init(nibName: nil, bundle: .module)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        let rightBarButtonItem = UIBarButtonItem(title: "Remove", style: .plain, target: self, action: #selector(removeAll(_:)))
        self.navigationItem.setRightBarButton(rightBarButtonItem, animated: false)
        
        let nib = UINib(nibName: "TSUserNotificationCheckTableViewCell", bundle: .module)
        tableView.register(nib, forCellReuseIdentifier: "TSUserNotificationCheckTableViewCell")

        setup()
    }
}

// MARK: - UITableViewDataSource
extension TSUserNotificationCheckViewController: UITableViewDataSource {
    public func numberOfSections(in tableView: UITableView) -> Int {
        return notifications.count
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let notification = notifications[section]
        return notification.details.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TSUserNotificationCheckTableViewCell", for: indexPath) as! TSUserNotificationCheckTableViewCell
        
        let section = indexPath.section
        let row = indexPath.row
        
        let detail = notifications[section].details[row]
        cell.row = row
        cell.detail = detail
        
        return cell
    }
    
    public func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let notification = notifications[section]
        return notification.threadIdentifier
    }
}

// MARK: - Help
private extension TSUserNotificationCheckViewController {
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
                            repeatDay = "Every Sun"
                        case 2:
                            repeatDay = "Every Mon"
                        case 3:
                            repeatDay = "Every Tue"
                        case 4:
                            repeatDay = "Every Wed"
                        case 5:
                            repeatDay = "Every Thu"
                        case 6:
                            repeatDay = "Every Fri"
                        case 7:
                            repeatDay = "Every Sat"
                        default:
                            break
                        }
                    } else if isRepeat == true {
                        if dateComponents.day == nil {
                            repeatDay = "Every day"
                        } else if dateComponents.month == nil {
                            repeatDay = "Every week"
                        } else if dateComponents.year == nil {
                            repeatDay = "Every month"
                        } else {
                            repeatDay = "Every year"
                        }
                    }
                    self.setup(identifier: request.identifier,
                               threadIdentifier: request.content.threadIdentifier,
                               fireDate: trigger.nextTriggerDate(),
                               alertTitle: request.content.title,
                               alertBody: request.content.body,
                               repeatDay: repeatDay)
                } else if let trigger = request.trigger as? UNTimeIntervalNotificationTrigger {
                    let repeatDay: String? = trigger.repeats ? "Repeat \(trigger.timeInterval)" : nil
                    self.setup(identifier: request.identifier,
                               threadIdentifier: request.content.threadIdentifier,
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
        var total = 0
        notifications.forEach { notification in
            total += notification.details.count
        }
        title = "PendingNoti (\(total))"
    }
    
    func setup(identifier: String, threadIdentifier: String?, fireDate: Date?, alertTitle: String?, alertBody: String?, repeatDay: String?) {
        var compareIdentifier: String
        if let threadIdentifier = threadIdentifier, !threadIdentifier.isEmpty {
            compareIdentifier = threadIdentifier
        } else {
            compareIdentifier = "none"
        }
        let notification: TSUserNotificationInfo
        if let tmp = notifications.filter({ $0.threadIdentifier == compareIdentifier }).first {
            notification = tmp
        } else {
            notification = TSUserNotificationInfo()
            notifications.append(notification)
            notification.threadIdentifier = compareIdentifier
        }
        
        let detail = TSUserNotificationInfoDetail()
        detail.identifier = identifier
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
private extension TSUserNotificationCheckViewController {
    @IBAction func removeAll(_ sender: Any) {
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
        setup()
    }
}
