//
//  DateExtension.swift
//  parstagram
//
//  Created by Richard Hsu on 2020/2/18.
//  Copyright © 2020 Richard Hsu. All rights reserved.
//

import Foundation

// Code obtained from: https://stackoverflow.com/questions/34457434/swift-convert-time-to-time-ago
extension Date {
    func getElapsedInterval() -> String {

        let interval = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: self, to: Date())

        if let year = interval.year, year > 0 {
            return "\(year) " + (year == 1 ? "year" : "years") + " ago"
        } else if let month = interval.month, month > 0 {
            return "\(month) " + (month == 1 ? "month" : "months") + " ago"
        } else if let day = interval.day, day > 0 {
            return "\(day) " + (day == 1 ? "day" : "days") + " ago"
        } else if let hour = interval.hour, hour > 0 {
            return "\(hour) " + (hour == 1 ? "hour" : "hours") + " ago"
        } else if let minute = interval.minute, minute > 0 {
            return "\(minute) " + (minute == 1 ? "minute" : "minutes") + " ago"
        } else if let second = interval.second, second > 0 {
            return "\(second) " + (second == 1 ? "second" : "seconds") + " ago"
        } else {
            return "a moment ago"
        }
    }
}
