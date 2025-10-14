//
//  TSUserNotification.swift
//  TSFramework
//
//  Created by TAE SU LEE on 2021/06/26.
//

import Foundation
import UserNotifications

public struct TSUserNotification {
    public var identifier: String = UUID().uuidString
    public var date: Date = Date()
    public var repeatType: TSUserNotificationRepeatType = .none
    public var title: String?
    public var subtitle: String?
    public var body: String?
    public var badge: Int?
    public var sound: UNNotificationSound?
    public var userInfo: [String: Any]?
    public var threadIdentifier: String?

    public init(
        identifier: String = UUID().uuidString,
        date: Date,
        repeatType: TSUserNotificationRepeatType = .none,
        title: String? = nil,
        subtitle: String? = nil,
        body: String? = nil,
        badge: Int? = nil,
        sound: UNNotificationSound? = nil,
        userInfo: [String: Any]? = nil,
        threadIdentifier: String? = nil
    ) {
        self.identifier = identifier
        self.date = date
        self.repeatType = repeatType
        self.title = title
        self.subtitle = subtitle
        self.body = body
        self.badge = badge
        self.sound = sound
        self.userInfo = userInfo
        self.threadIdentifier = threadIdentifier
    }
}

extension TSUserNotification {
    var dateComponents: DateComponents {
        Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: date)
    }
}
