//
//  TSUserNotificationCheckTableViewCell.swift
//  TSFramework
//
//  Created by TAE SU LEE on 2021/06/22.
//

import UIKit
import UserNotifications

class TSUserNotificationCheckTableViewCell: UITableViewCell {
    @IBOutlet weak var numberLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var messageLabel: UILabel!
    
    private let dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"
        return dateFormatter
    }()
    
    var row: Int = 0
    var detail: TSUserNotificationInfoDetail? {
        didSet {
            guard let detail = detail else { return }
            numberLabel.text = "\(row+1)"
            var timeString: String = dateFormatter.string(from: detail.date)
            if detail.repeatDay.count > 0 {
                timeString += " (\(detail.repeatDay))"
            }
            timeLabel.text = timeString
            var message: String = ""
            if !detail.title.isEmpty {
                message += detail.title + "\n"
            }
            message += detail.message
            messageLabel.text = message
        }
    }
}
