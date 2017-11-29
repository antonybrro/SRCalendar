//
//  Date.swift
//  Calendar
//
//  Created by Antony Yurchenko on 11/28/17.
//  Copyright © 2017 Antony Yurchenko. All rights reserved.
//

import Foundation

extension Date {
    func calendar() -> Calendar {
        let calendar = Calendar(identifier: .gregorian)
        return calendar
    }
    
    func firstDayOfTheMonth() -> Date {
        var components = calendar().dateComponents([.year, .month, .day], from: self)
        components.day = 1
        return calendar().date(from: components)!
    }
    
    func numberOfMonth() -> Int {
        return calendar().dateComponents([.month], from: self, to: Date()).month! + 1
    }
    
    func weekDay() -> Int {
        return calendar().dateComponents([.weekday], from: self).weekday!
    }
    
    func numberOfDaysInMonth() -> Int {
        return calendar().range(of: .day, in: .month, for: self)!.count
    }
    
    func dayComponents() ->Int {
        return calendar().component(.day, from: self)
    }
    
    func weekdaySymbols() -> [String] {
        var symbols = [String]()
        for day in DateFormatter().shortWeekdaySymbols {
            symbols.append(day)
        }
        
        return symbols
    }
    
    func monthSymbol(at index: Int) -> String {
        return DateFormatter().monthSymbols[index - 1]
    }
}
