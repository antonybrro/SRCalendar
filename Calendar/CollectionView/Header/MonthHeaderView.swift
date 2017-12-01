//
//  MonthHeaderView.swift
//  Calendar
//
//  Created by Antony Yurchenko on 11/28/17.
//  Copyright © 2017 Antony Yurchenko. All rights reserved.
//

import UIKit

class MonthHeaderView: UICollectionReusableView {
    
    var monthLabel: UILabel!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setup()
    }
    
    func setup() {
        self.clipsToBounds = true
        
        monthLabel = UILabel(frame: CGRect(x: 0, y: 0, width: self.frame.width, height: 30))
        monthLabel.textAlignment = .left
        monthLabel.font = UIFont.systemFont(ofSize: 22)
        monthLabel.textColor = UIColor.Calendar.Header.month
        monthLabel.text = "Month"
        addSubview(monthLabel)
        
        let yOffset: CGFloat = 30
        let oneLabelWidth: CGFloat = self.frame.width / 7
        let oneLabelHeight: CGFloat = 20
        var xOffset: CGFloat = 0.0
        var weekDays = Date().weekdaySymbols()
        
        if Calendar.current.firstWeekday == 2 {
            let element = weekDays.remove(at: 0)
            weekDays.insert(element, at: 6)
        }
        
        var x: CGFloat = 0
        
        for i in 0..<7 {
            let day = UILabel(frame: CGRect(x: xOffset, y: yOffset, width: oneLabelWidth, height: oneLabelHeight))
            day.textAlignment = .center
            day.font = UIFont.systemFont(ofSize: 12)
            day.text = weekDays[i].uppercased()
            day.textColor = i == 5 || i == 6 ? UIColor.Calendar.Header.weekday : UIColor.Calendar.Header.weekdayWithOpacity
            addSubview(day)
            xOffset += oneLabelWidth
            
            if i == 0 {
                x = (day.frame.width - day.intrinsicContentSize.width) / 2
            }
        }
        
        monthLabel.frame = CGRect(x: x, y: 0, width: self.frame.width - x, height: 30)
    }
}
