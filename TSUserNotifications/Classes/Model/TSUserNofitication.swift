//
//  TSUserNofitication.swift
//  TSFramework
//
//  Created by TAE SU LEE on 2021/06/26.
//

import Foundation

public struct TSUserNofitication {
    var identifier: String = UUID().uuidString
    var date: Date = Date()
    var repeatType: TSUserNotificationRepeatType = .none
    var title: String?
    var subtitle: String?
    var body: String?
    var badge: Int?
    var sound: UNNotificationSound?
    var userInfo: [String: Any]?
    var threadIdentifier: String?
    
    public init(identifier: String = UUID().uuidString,
         date: Date,
         repeatType: TSUserNotificationRepeatType = .none,
         title: String? = nil,
         subtitle: String? = nil,
         body: String? = nil,
         badge: Int? = nil,
         sound: UNNotificationSound? = nil,
         userInfo: [String: Any]? = nil,
         threadIdentifier: String? = nil) {
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

extension TSUserNofitication {
    var dateComponents: DateComponents {
        Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: date)
    }
}
