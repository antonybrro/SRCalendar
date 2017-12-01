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
    var dayType: DayType!
    
    let gradientLayerName = "gradientLayer"
    let circleLayerName = "circleLayer"
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    
        setupGradientLayer()
        setupDayLabel()
    }
    
    private func setupGradientLayer() {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = CGRect(x: (self.frame.width - 30) / 2, y: (self.frame.height - 30) / 2, width: 30, height: 30)
        gradientLayer.colors = UIColor.Calendar.selectedDate.colors
        gradientLayer.locations = UIColor.Calendar.selectedDate.locations
        gradientLayer.cornerRadius = gradientLayer.frame.width / 2
        gradientLayer.startPoint = CGPoint(x: 0, y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 1, y: 0.5)
        gradientLayer.isHidden = true
        gradientLayer.name = gradientLayerName
        self.layer.addSublayer(gradientLayer)
    }
    
    private func setupDayLabel() {
        day = UILabel(frame: self.contentView.bounds)
        day.textAlignment = .center
        day.font = UIFont.systemFont(ofSize: 12)
        self.addSubview(day)
    }
    
    private func setupTodayCircle() {
        let circleLayer = CAShapeLayer()
        circleLayer.path = UIBezierPath(ovalIn: CGRect(x: (self.frame.width - 30) / 2, y: (self.frame.height - 30) / 2, width: 30, height: 30)).cgPath
        circleLayer.fillColor = UIColor.clear.cgColor
        circleLayer.strokeColor = UIColor.Calendar.Cell.weekend.cgColor
        circleLayer.lineWidth = 1
        circleLayer.name = circleLayerName
        self.day.layer.addSublayer(circleLayer)
    }
    
    func setupCell(_ day: String, _ dayType: DayType) {
        removeTodayCircle()
        self.day.text = day
        self.dayType = dayType
    
        self.layer.getLayer(by: gradientLayerName)?.isHidden = true
        
        switch dayType {
        case .today:
            setupTodayCircle()
        case .workday:
            self.day.textColor = UIColor.Calendar.Cell.workday
        case .weekend:
            self.day.textColor = UIColor.Calendar.Cell.weekend
        case .workdayUnavaliable:
            self.day.textColor = UIColor.Calendar.Cell.workdayWithOpacity
        case .weekendUnavaliable:
            self.day.textColor = UIColor.Calendar.Cell.weekendWithOpacity
        case .empty:
            break
        }
    }
    
    func removeTodayCircle() {
        self.day.layer.getLayer(by: circleLayerName)?.removeFromSuperlayer()
    }
    
    func select() {
        day.textColor = .white
        
        self.layer.getLayer(by: gradientLayerName)?.isHidden = false
    }
    
    func unselect() {
        day.textColor = .black
        self.layer.getLayer(by: gradientLayerName)?.isHidden = true
    }
}

extension CALayer {
    func getLayer(by name: String) -> CALayer? {
        let layer = self.sublayers?.first(where: { (layer: CALayer) -> Bool in
            return layer.name == name
        })
        
        return layer
    }
}
