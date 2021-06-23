//
//  TSUserNotificationInfo.swift
//  TSFramework
//
//  Created by TAE SU LEE on 2021/06/22.
//

import Foundation

class TSUserNotificationInfo {
    var threadIdentifier: String = "none"
    var details: [TSUserNotificationInfoDetail] = []
}

class TSUserNotificationInfoDetail: NSObject {
    var date: Date = Date()
    var title: String = ""
    var key: String = ""
    var message: String = ""
    var repeatDay: String = ""
}
