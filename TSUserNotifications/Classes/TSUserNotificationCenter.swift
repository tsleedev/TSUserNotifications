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

final class TSUserNofitactionFireDate {
    private var year: Int?
    private var month: Int?
    private var day: Int?
    private var hour: Int?
    private var minute: Int?
    private var second: Int?
    private var repeatType: TSUserNotificationRepeatType = .none
    private var dayOfTheWeek: TSUserNotificationDayOfTheWeek?
    
    init(year: Int? = nil,
         month: Int? = nil,
         day: Int? = nil,
         hour: Int? = nil,
         minute: Int? = nil,
         second: Int? = nil,
         repeatType: TSUserNotificationRepeatType = .none,
         dayOfTheWeek: TSUserNotificationDayOfTheWeek? = nil) {
        self.year = year
        self.month = month
        self.day = day
        self.hour = hour
        self.minute = minute
        self.second = second
        self.repeatType = repeatType
        self.dayOfTheWeek = dayOfTheWeek
    }
}

private extension TSUserNofitactionFireDate {
    var dateComponents: DateComponents {
        var components: DateComponents
        switch repeatType {
        case .none:
            components = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: Date())
        case .day:
            components = Calendar.current.dateComponents([.hour, .minute, .second], from: Date())
        case .week:
            components = Calendar.current.dateComponents([.weekday, .hour, .minute, .second], from: Date())
        case .month:
            components = Calendar.current.dateComponents([.day, .hour, .minute, .second], from: Date())
        case .year:
            components = Calendar.current.dateComponents([.month, .day, .hour, .minute, .second], from: Date())
        }
        components.weekday = dayOfTheWeek?.rawValue
        components.year = year
        components.month = month
        components.day = day
        components.hour = hour
        components.minute = minute
        components.second = second
        return components
    }
}

public class TSUserNotificationCenter {
    @discardableResult
    public static func set(identifier: String = UUID().uuidString,
                    date: Date?,
                    repeatType: TSUserNotificationRepeatType = .none,
                    title: String? = nil,
                    subtitle: String? = nil,
                    body: String?,
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
                    body: String?,
                    badge: Int? = nil,
                    sound: UNNotificationSound? = nil,
                    userInfo: [String: Any]? = nil,
                    threadIdentifier: String? = nil) -> Bool {
        let userNofitactionFireDate = TSUserNofitactionFireDate(year: year,
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
                    fireDate: TSUserNofitactionFireDate,
                    repeats: Bool = false,
                    title: String?,
                    subtitle: String?,
                    body: String?,
                    badge: Int?,
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
                    title: String?,
                    subtitle: String?,
                    body: String?,
                    badge: Int?,
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
            let userNofitactionFireDate = TSUserNofitactionFireDate(hour: hour,
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
            let userNofitactionFireDate = TSUserNofitactionFireDate(hour: hour,
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
    static func remove(identifiers: [String]) {
        DispatchQueue.main.async {
            UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: identifiers)
            print("UNUserNotificationCenter removes : \(identifiers)")
        }
    }
    
    static func removeContain(identifier: String) {
        UNUserNotificationCenter.current().getPendingNotificationRequests { requests in
            let identifiers = requests.filter { $0.identifier.contains(identifier) }.map { $0.identifier }
            remove(identifiers: identifiers)
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
        if Calendar.current.compare(Date(), to: date, toGranularity: .second) == ComparisonResult.orderedDescending {
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
