//
//  Date.swift
//  SRCalendar
//
//  Created by Antony Yurchenko on 11/28/17.
//  Copyright © 2017 Antony Yurchenko. All rights reserved.
//

import Foundation

enum DayType {
    case empty
    case today
    case workday
    case weekend
    case workdayUnavaliable
    case weekendUnavaliable
}

extension Date {
    func firstDayOfTheMonth() -> Date {
        var components = Calendar.current.dateComponents([.year, .month, .day], from: self)
        components.day = 1
        return Calendar.current.date(from: components)!
    }
    
    func numberOfMonth(_ to: Date) -> Int {
        return Calendar.current.dateComponents([.month], from: self, to: to).month! + 2
    }
    
    func numberOfDaysInMonth() -> Int {
        return Calendar.current.range(of: .day, in: .month, for: self)!.count
    }
    
    func weekDay() -> Int {
        var weekDay = Calendar.current.dateComponents([.weekday], from: self).weekday!
        
        if Calendar.current.firstWeekday == 2 {
            weekDay = weekDay - 1
            weekDay = weekDay == 0 ? 7 : weekDay
        }
        
        return weekDay
    }
    
    func dayComponents() ->Int {
        return Calendar.current.component(.day, from: self)
    }
    
    func monthSymbol(at index: Int) -> String {
        return DateFormatter().monthSymbols[index - 1]
    }
    
    func weekdaySymbols() -> [String] {
        var symbols = [String]()
        for day in DateFormatter().shortWeekdaySymbols {
            symbols.append(day)
        }
        
        return symbols
    }
    
    func getDayType() -> DayType {
        if Calendar.current.isDateInToday(self) {
            return .today
        }
        
        if toDate > self {
            return Calendar.current.isDateInWeekend(self) ? .weekend : .workday
        } else {
            return Calendar.current.isDateInWeekend(self) ? .weekendUnavaliable : .workdayUnavaliable
        }
    }
    
    func stringRepresentation(_ format: String? = nil) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = format ?? "dd.MM.yyyy"
        return formatter.string(from: self)
    }
}
