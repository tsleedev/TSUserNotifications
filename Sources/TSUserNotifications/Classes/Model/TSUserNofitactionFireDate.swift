//
//  TSUserNofitactionFireDate.swift
//  TSUserNotifications
//
//  Created by tsleedev on 2021/06/26.
//

import Foundation

public struct TSUserNofitactionFireDate {
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

extension TSUserNofitactionFireDate {
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
