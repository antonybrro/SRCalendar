//
//  CollectionViewCell.swift
//  Calendar
//
//  Created by Antony Yurchenko on 11/28/17.
//  Copyright © 2017 Antony Yurchenko. All rights reserved.
//

import UIKit

class CollectionViewCell: UICollectionViewCell {
    var day: UILabel!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        day = UILabel(frame: self.contentView.bounds)
        day.textAlignment = .center
        day.font = UIFont.systemFont(ofSize: 12)
        self.addSubview(day)
    }
    
    func setupCell(_ day: String, _ dayType: DayType = .workday) {
        self.day.text = day
        
        self.day.layer.sublayers?.first(where: { (layer: CALayer) -> Bool in
            guard let circleLayer = layer as? CAShapeLayer else {
                return false
            }
            
            return circleLayer.name == "circleLayer"
        })?.removeFromSuperlayer()
        
        switch dayType {
        case .today:
            let circleLayer = CAShapeLayer()
            circleLayer.path = UIBezierPath(ovalIn: CGRect(x: (self.frame.width - 30) / 2, y: (self.frame.height - 30) / 2, width: 30, height: 30)).cgPath
            circleLayer.fillColor = UIColor.clear.cgColor
            circleLayer.strokeColor = UIColor.Calendar.Cell.weekend.cgColor
            circleLayer.lineWidth = 2
            circleLayer.name = "circleLayer"
            self.day.layer.addSublayer(circleLayer)
        case .workday:
            self.day.textColor = UIColor.Calendar.Cell.workday
            break
        case .weekend:
            self.day.textColor = UIColor.Calendar.Cell.weekend
        case .workdayUnavaliable:
            self.day.textColor = UIColor.Calendar.Cell.workdayWithOpacity
        case .weekendUnavaliable:
            self.day.textColor = UIColor.Calendar.Cell.weekendWithOpacity
        }
    }
}
