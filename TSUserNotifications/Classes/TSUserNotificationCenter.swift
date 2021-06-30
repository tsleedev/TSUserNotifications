//
//  TSUserNotificationCenter.swift
//  TSFramework
//
//  Created by TAE SU LEE on 2021/06/22.
//

import Foundation
import UserNotifications

public enum TSUserNotificationRepeatType {
    case none
    case day
    case week
    case month
    case year
}

public enum TSUserNotificationDayOfTheWeek: Int {
    case sunday = 1
    case monday
    case tuesday
    case wednesday
    case thursday
    case friday
    case saturday
}

public class TSUserNotificationCenter {}

// MARK: - Public
public extension TSUserNotificationCenter {
    @discardableResult
    static func set(identifier: String = UUID().uuidString,
                    date: Date?,
                    repeatType: TSUserNotificationRepeatType = .none,
                    title: String? = nil,
                    subtitle: String? = nil,
                    body: String? = nil,
                    badge: Int? = nil,
                    sound: UNNotificationSound? = nil,
                    userInfo: [String: Any]? = nil,
                    threadIdentifier: String? = nil) -> Bool {
        guard let date = date else { return false }
        let components = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: date)
        guard let hour = components.hour, let miniute = components.minute else { return false }
        return set(identifier: identifier,
                   year: components.year,
                   month: components.month,
                   day: components.day,
                   hour: hour,
                   miniute: miniute,
                   repeatType: repeatType,
                   title: title,
                   subtitle: subtitle,
                   body: body,
                   badge: badge,
                   sound: sound,
                   userInfo: userInfo,
                   threadIdentifier: threadIdentifier)
    }
    
    @discardableResult
    static func set(identifier: String = UUID().uuidString,
                    year: Int? = nil,
                    month: Int? = nil,
                    day: Int? = nil,
                    hour: Int,
                    miniute: Int,
                    second: Int = 0,
                    repeatType: TSUserNotificationRepeatType = .none,
                    title: String? = nil,
                    subtitle: String? = nil,
                    body: String? = nil,
                    badge: Int? = nil,
                    sound: UNNotificationSound? = nil,
                    userInfo: [String: Any]? = nil,
                    threadIdentifier: String? = nil) -> Bool {
        let userNofitactionFireDate = TSUserNotificationFireDate(year: year,
                                                                month: month,
                                                                day: day,
                                                                hour: hour,
                                                                minute: miniute,
                                                                second: second,
                                                                repeatType: repeatType)
        return set(identifier: identifier,
                   fireDate: userNofitactionFireDate,
                   repeats: repeatType != .none,
                   title: title,
                   subtitle: subtitle,
                   body: body,
                   badge: badge,
                   sound: sound,
                   userInfo: userInfo,
                   threadIdentifier: threadIdentifier)
    }
    
    @discardableResult
    static func set(identifier: String = UUID().uuidString,
                    fireDate: TSUserNotificationFireDate,
                    repeats: Bool = false,
                    title: String? = nil,
                    subtitle: String? = nil,
                    body: String? = nil,
                    badge: Int? = nil,
                    sound: UNNotificationSound? = nil,
                    userInfo: [String: Any]? = nil,
                    threadIdentifier: String? = nil) -> Bool {
        return set(identifier: identifier,
                   dateComponents: fireDate.dateComponents,
                   repeats: repeats,
                   title: title,
                   subtitle: subtitle,
                   body: body,
                   badge: badge,
                   sound: sound,
                   userInfo: userInfo,
                   threadIdentifier: threadIdentifier)
    }
    
    @discardableResult
    static func set(identifier: String = UUID().uuidString,
                    dateComponents: DateComponents?,
                    repeats: Bool = false,
                    title: String? = nil,
                    subtitle: String? = nil,
                    body: String? = nil,
                    badge: Int? = nil,
                    sound: UNNotificationSound? = nil,
                    userInfo: [String: Any]? = nil,
                    threadIdentifier: String? = nil) -> Bool {
        guard let dateComponents = dateComponents else { return false }
        let content = setupNotificationContent(title: title,
                                               subtitle: subtitle,
                                               body: body,
                                               badge: badge,
                                               sound: sound,
                                               userInfo: userInfo,
                                               threadIdentifier: threadIdentifier)
        return set(identifier: identifier,
                   dateComponents: dateComponents,
                   repeats: repeats,
                   content: content)
    }
}

// MARK: - DayOfTheWeek
public extension TSUserNotificationCenter {
    static func setDayOfTheWeek(identifier: String = UUID().uuidString,
                                hour: Int,
                                miniute: Int,
                                second: Int = 0,
                                dayOfTheWeeks: [TSUserNotificationDayOfTheWeek],
                                repeats: Bool = true,
                                title: String?,
                                subtitle: String?,
                                body: String?,
                                badge: Int?,
                                sound: UNNotificationSound? = nil,
                                userInfo: [String: Any]? = nil,
                                threadIdentifier: String? = nil) {
        var identifiers: [String] = [identifier]
        for index in 1...7 {
            identifiers.append("\(identifier)\(index)")
        }
        remove(identifiers: identifiers)
        if dayOfTheWeeks.count >= 7 {
            let userNofitactionFireDate = TSUserNotificationFireDate(hour: hour,
                                                                    minute: miniute,
                                                                    second: second,
                                                                    repeatType: .day)
            set(identifier: identifier,
                fireDate: userNofitactionFireDate,
                repeats: repeats,
                title: title,
                subtitle: subtitle,
                body: body,
                badge: badge,
                sound: sound,
                userInfo: userInfo,
                threadIdentifier: threadIdentifier)
            return
        }
        dayOfTheWeeks.forEach { dayOfTheWeek in
            let userNofitactionFireDate = TSUserNotificationFireDate(hour: hour,
                                                                    minute: miniute,
                                                                    second: second,
                                                                    repeatType: .week,
                                                                    dayOfTheWeek: dayOfTheWeek)
            set(identifier: identifier + "\(dayOfTheWeek.rawValue)",
                fireDate: userNofitactionFireDate,
                repeats: repeats,
                title: title,
                subtitle: subtitle,
                body: body,
                badge: badge,
                sound: sound,
                userInfo: userInfo,
                threadIdentifier: threadIdentifier)
        }
    }
}

// MARK: - Remove
public extension TSUserNotificationCenter {
    static func remove(identifiers: [String], completion: (() -> Void)? = nil) {
        DispatchQueue.main.async {
            UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: identifiers)
            print("UNUserNotificationCenter removes : \(identifiers)")
            completion?()
        }
    }
    
    static func removeContain(identifier: String, completion: @escaping () -> Void) {
        UNUserNotificationCenter.current().getPendingNotificationRequests { requests in
            let identifiers = requests.filter { $0.identifier.contains(identifier) }.map { $0.identifier }
            remove(identifiers: identifiers, completion: completion)
        }
    }
    
    static func removeAll() {
        DispatchQueue.main.async {
            UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
        }
    }
}

// MARK: - Helper
private extension TSUserNotificationCenter {
    static func setupNotificationContent(title: String?,
                                         subtitle: String?,
                                         body: String?,
                                         badge: Int?,
                                         sound: UNNotificationSound? = nil,
                                         userInfo: [String: Any]? = nil,
                                         threadIdentifier: String? = nil) -> UNMutableNotificationContent {
        let content = UNMutableNotificationContent()
        if let title = title {
            content.title = title
        }
        if let subtitle = subtitle {
            content.subtitle = subtitle
        }
        if let body = body {
            content.body = body
        }
        if let badge = badge {
            content.badge = badge as NSNumber?
        }
        if let sound = sound {
            content.sound = sound
        }
        if let userInfo = userInfo {
            content.userInfo = userInfo
        }
        if let threadIdentifier = threadIdentifier {
            content.threadIdentifier = threadIdentifier
        }
        return content
    }
    
    static func set(identifier: String,
                    dateComponents: DateComponents,
                    repeats: Bool = false,
                    content: UNNotificationContent) -> Bool {
        guard let date = Calendar.current.date(from: dateComponents) else { return false }
        if Calendar.current.compare(Date(), to: date, toGranularity: .second) == .orderedDescending {
            if !repeats {
                return false
            }
        }
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: repeats)
        let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
        DispatchQueue.main.async {
            UNUserNotificationCenter.current().add(request, withCompletionHandler: { (error) in
                if let error = error {
                    print("UNUserNotificationCenter add = \(error.localizedDescription)")
                } else {
                    print("UNUserNotificationCenter add = \(identifier)")
                }
            })
        }
        return true
    }
}
