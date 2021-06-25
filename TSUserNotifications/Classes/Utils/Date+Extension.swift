//
//  Date+Extension.swift
//  TSFramework
//
//  Created by TAE SU LEE on 2021/06/25.
//

import UIKit

// MARK: Calculator Next Date
extension Date {
    func nextDay(from today: Date = Date()) -> Date? {
        let today = Date()
        let calendar = Calendar.current
        let todayComponents = calendar.dateComponents([.year, .month, .day, .hour, .minute], from: today)
        var dateComponents = calendar.dateComponents([.year, .month, .day, .hour, .minute], from: self)
        dateComponents.year = todayComponents.year
        dateComponents.month = todayComponents.month
        dateComponents.day = todayComponents.day
        
        if let tmpDate = calendar.date(from: dateComponents) {
            if calendar.compare(today, to: tmpDate, toGranularity: .second) == .orderedDescending {
                dateComponents.day! += 1
            }
        }
        return calendar.date(from: dateComponents)
    }
    
    func nextWeek(from today: Date = Date()) -> Date? {
        let calendar = Calendar.current
        var todayComponents = calendar.dateComponents([.year, .month, .day, .hour, .minute, .weekday], from: today)
        let dateComponents = calendar.dateComponents([.year, .month, .day, .hour, .minute, .weekday], from: self)
        
        todayComponents.day = todayComponents.day! + (dateComponents.weekday! - todayComponents.weekday!)
        todayComponents.hour = dateComponents.hour
        todayComponents.minute = dateComponents.minute
        
        if let tmpDate = calendar.date(from: todayComponents) {
            if calendar.compare(today, to: tmpDate, toGranularity: .second) == .orderedDescending {
                todayComponents.day! += 7
            }
        }
        
        return calendar.date(from: todayComponents)
    }
    
    func nextMonth(from today: Date = Date()) -> Date? {
        let calendar = Calendar.current
        var todayComponents = calendar.dateComponents([.year, .month, .day, .hour, .minute], from: today)
        var dateComponents = calendar.dateComponents([.year, .month, .day, .hour, .minute], from: self)
        dateComponents.year = todayComponents.year
        dateComponents.month = todayComponents.month
        
        if let tmpDate = calendar.date(from: dateComponents) {
            let month = calendar.component(.month, from: tmpDate)
            if month != dateComponents.month! ||
                calendar.compare(today, to: tmpDate, toGranularity: .second) == .orderedDescending {
                todayComponents.month! += 1
                todayComponents.day = 1
                todayComponents.hour = 0
                todayComponents.minute = 0
                if let nextMonth1st = calendar.date(from: todayComponents) {
                    return nextMonth(from: nextMonth1st)
                }
            }
            return tmpDate
        }
        return nil
    }
    
    func nextYear(from today: Date = Date()) -> Date? {
        let calendar = Calendar.current
        var todayComponents = calendar.dateComponents([.year, .month, .day, .hour, .minute], from: today)
        var dateComponents = calendar.dateComponents([.year, .month, .day, .hour, .minute], from: self)
        dateComponents.year = todayComponents.year
        
        if let tmpDate = calendar.date(from: dateComponents) {
            let month = calendar.component(.month, from: tmpDate)
            if month != dateComponents.month! ||
                calendar.compare(today, to: tmpDate, toGranularity: .second) == .orderedDescending {
                todayComponents.year! += 1
                todayComponents.month = 1
                todayComponents.day = 1
                todayComponents.hour = 0
                todayComponents.minute = 0
                if let nextYear1st = calendar.date(from: todayComponents) {
                    return nextYear(from: nextYear1st)
                }
            }
            return tmpDate
        }
        return nil
    }
}
