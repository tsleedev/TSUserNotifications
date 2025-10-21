//
//  TSUserNotificationCenter+Notifications.swift
//  TSUserNotifications
//
//  Created by TAE SU LEE on 2021/06/28.
//

import Foundation

// MARK: - Order of priority
public extension TSUserNotificationCenter {
    /// iOS의 pending notification 최대 개수 제한
    static let maxPendingNotifications = 64

    @discardableResult
    static func set(notification: TSUserNotification) -> Bool {
        return set(
            identifier: notification.identifier,
            dateComponents: notification.dateComponents,
            repeats: false,
            title: notification.title,
            subtitle: notification.subtitle,
            body: notification.body,
            badge: notification.badge,
            sound: notification.sound,
            userInfo: notification.userInfo,
            threadIdentifier: notification.threadIdentifier)
    }

    static func set(notifications: [TSUserNotification], max: Int = maxPendingNotifications) {
        guard max > 0 else {
            print("The max must be greater than 0.")
            return
        }
        guard max <= maxPendingNotifications else {
            print("The max must be \(maxPendingNotifications) or less.")
            return
        }
        guard !notifications.isEmpty else {
            print("Notifications array cannot be empty.")
            return
        }

        let today = Date()
        let calendar = Calendar.current

        var availableNotifications: [TSUserNotification] = []
        notifications.forEach {
            switch $0.repeatType {
            case .none:
                if calendar.compare(today, to: $0.date, toGranularity: .second) == .orderedAscending {
                    availableNotifications.append($0)
                }
            case .day:
                if let date = $0.date.nextDay() {
                    var notification = $0
                    notification.date = date
                    availableNotifications.append(notification)
                }
            case .week:
                if let date = $0.date.nextWeek() {
                    var notification = $0
                    notification.date = date
                    availableNotifications.append(notification)
                }
            case .month:
                if let date = $0.date.nextMonth() {
                    var notification = $0
                    notification.date = date
                    availableNotifications.append(notification)
                }
            case .year:
                if let date = $0.date.nextYear() {
                    var notification = $0
                    notification.date = date
                    availableNotifications.append(notification)
                }
            }
        }

        availableNotifications.sort {
            calendar.compare($0.date, to: $1.date, toGranularity: .second) == .orderedAscending
        }
        if max < availableNotifications.count {
            availableNotifications.removeSubrange(max...)
        }

        var availableAllNotifications: [TSUserNotification] = []
        availableNotifications.forEach {
            var compareDate = Date()
            switch $0.repeatType {
            case .none:
                if calendar.compare(today, to: $0.date, toGranularity: .second) == .orderedAscending {
                    availableAllNotifications.append($0)
                }
            case .day:
                for index in 1...max {
                    if let date = $0.date.nextDay(from: compareDate) {
                        var notification = $0
                        notification.identifier += "_\(index)"
                        notification.date = date
                        availableAllNotifications.append(notification)
                        compareDate = date.adding(days: 1)
                    }
                }
            case .week:
                for index in 1...max {
                    if let date = $0.date.nextWeek(from: compareDate) {
                        var notification = $0
                        notification.identifier += "_\(index)"
                        notification.date = date
                        availableAllNotifications.append(notification)
                        compareDate = date.adding(weeks: 1)
                    }
                }
            case .month:
                for index in 1...max {
                    if let date = $0.date.nextMonth(from: compareDate) {
                        var notification = $0
                        notification.identifier += "_\(index)"
                        notification.date = date
                        availableAllNotifications.append(notification)
                        compareDate = date.adding(months: 1)
                    }
                }
            case .year:
                for index in 1...max {
                    if let date = $0.date.nextYear(from: compareDate) {
                        var notification = $0
                        notification.identifier += "_\(index)"
                        notification.date = date
                        availableAllNotifications.append(notification)
                        compareDate = date.adding(years: 1)
                    }
                }
            }
        }

        let sortedAscendingNotifications = availableAllNotifications.sorted {
            calendar.compare($0.date, to: $1.date, toGranularity: .second) == .orderedAscending
        }

        for index in 0...max - 1 {
            if index >= sortedAscendingNotifications.count { break }
            let notification = sortedAscendingNotifications[index]
            set(notification: notification)
        }
    }
}
