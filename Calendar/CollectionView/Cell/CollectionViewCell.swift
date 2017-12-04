//
//  CollectionViewCell.swift
//  Calendar
//
//  Created by Antony Yurchenko on 11/28/17.
//  Copyright © 2017 Antony Yurchenko. All rights reserved.
//

import UIKit

enum CellRangePisition {
    case left
    case right
    case center
}

class CollectionViewCell: UICollectionViewCell {
    var day: UILabel!
    var dayType: DayType!
    
    let gradientLayerName = "gradientLayer"
    let fillLayerName = "fillLayer"
    let circleLayerName = "circleLayer"
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    
        setupDayLabel()
    }
    
    private func setupGradientLayer() {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = CGRect(x: (self.frame.width - 30) / 2, y: (self.frame.height - 30) / 2, width: 30, height: 30)
        gradientLayer.colors = UIColor.Calendar.Cell.selectedCell.colors
        gradientLayer.locations = UIColor.Calendar.Cell.selectedCell.locations
        gradientLayer.cornerRadius = gradientLayer.frame.width / 2
        gradientLayer.startPoint = CGPoint(x: 0, y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 1, y: 0.5)
        gradientLayer.name = gradientLayerName
        
        addSublayerToBackgroundView(gradientLayer)
    }
    
    private func setupFillLayer(_ position: CellRangePisition) {
        let fillLayer = CALayer()
        
        fillLayer.backgroundColor = UIColor.Calendar.Cell.fill.cgColor
        fillLayer.name = fillLayerName
        
        switch position {
        case .left:
            fillLayer.frame = CGRect(x: self.frame.width / 2, y: (self.frame.height - 30) / 2, width: self.frame.width / 2, height: 30)
        case .right:
            fillLayer.frame = CGRect(x: 0, y: (self.frame.height - 30) / 2, width: self.frame.width / 2, height: 30)
        case .center:
            fillLayer.frame = CGRect(x: 0, y: (self.frame.height - 30) / 2, width: self.frame.width, height: 30)
        }
        
        addSublayerToBackgroundView(fillLayer)
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
        
        addSublayerToBackgroundView(circleLayer)
    }
    
    private func addSublayerToBackgroundView(_ layer: CALayer) {
        if let backgroundView = self.backgroundView {
            backgroundView.layer.addSublayer(layer)
        } else {
            self.backgroundView = UIView(frame: self.frame)
            self.backgroundView!.layer.addSublayer(layer)
        }
    }
    
    func setupCell(_ day: String, _ dayType: DayType) {
        removeTodayCircle()
        unselect()
        removeFill()
        
        self.day.text = day
        self.dayType = dayType
            
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
    
    private func removeTodayCircle() {
        self.backgroundView?.layer.getLayer(by: circleLayerName)?.removeFromSuperlayer()
    }
    
    func select() {
        day.textColor = .white
        setupGradientLayer()
    }
    
    private func unselect() {
        day.textColor = .black
        self.backgroundView?.layer.getLayer(by: gradientLayerName)?.removeFromSuperlayer()
    }
    
    func fillCell(_ position: CellRangePisition) {
        setupFillLayer(position)
    }
    
    private  func removeFill() {
        self.backgroundView?.layer.getLayer(by: fillLayerName)?.removeFromSuperlayer()
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
