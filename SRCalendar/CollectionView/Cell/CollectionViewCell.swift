//
//  CollectionViewCell.swift
//  SRCalendar
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
    
    private func setupDayLabel() {
        day = UILabel(frame: self.contentView.bounds)
        day.textAlignment = .center
        day.font = UIFont.systemFont(ofSize: 12)
        self.addSubview(day)
    }
    
    private func setupTodayCircleLayer() {
        let circleLayer = CAShapeLayer()
        circleLayer.path = UIBezierPath(ovalIn: CGRect(x: (self.frame.width - 30) / 2, y: (self.frame.height - 30) / 2, width: 30, height: 30)).cgPath
        circleLayer.fillColor = UIColor.clear.cgColor
        circleLayer.strokeColor = UIColor.SRCalendar.Cell.weekend.cgColor
        circleLayer.lineWidth = 1
        circleLayer.name = circleLayerName
        
        addSublayerToBackgroundView(circleLayer)
    }
    
    private func setupGradientLayer() {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = CGRect(x: (self.frame.width - 30) / 2, y: (self.frame.height - 30) / 2, width: 30, height: 30)
        gradientLayer.colors = UIColor.SRCalendar.Cell.selectedCell.colors
        gradientLayer.locations = UIColor.SRCalendar.Cell.selectedCell.locations
        gradientLayer.cornerRadius = gradientLayer.frame.width / 2
        gradientLayer.startPoint = CGPoint(x: 0, y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 1, y: 0.5)
        gradientLayer.name = gradientLayerName
        
        addSublayerToBackgroundView(gradientLayer)
    }
    
    private func setupFillLayer(_ position: CellRangePisition) {
        let fillLayer = CALayer()
        
        fillLayer.backgroundColor = UIColor.SRCalendar.Cell.fill.cgColor
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
    
    private func addSublayerToBackgroundView(_ layer: CALayer) {
        if let backgroundView = self.backgroundView {
            backgroundView.layer.addSublayer(layer)
        } else {
            self.backgroundView = UIView(frame: self.frame)
            self.backgroundView!.layer.addSublayer(layer)
        }
    }
    
    func select() {
        day.textColor = .white
        setupGradientLayer()
    }
    
    func fill(_ position: CellRangePisition) {
        setupFillLayer(position)
    }
    
    private func clearSelection() {
        day.textColor = .black
        self.backgroundView?.layer.getLayer(by: gradientLayerName)?.removeFromSuperlayer()
    }
    
    private  func clearFill() {
        self.backgroundView?.layer.getLayer(by: fillLayerName)?.removeFromSuperlayer()
    }
    
    private func clearTodayCircle() {
        self.backgroundView?.layer.getLayer(by: circleLayerName)?.removeFromSuperlayer()
    }
    
    func setupCell(_ day: String, _ dayType: DayType) {
        self.clipsToBounds = true
        
        clearTodayCircle()
        clearSelection()
        clearFill()
        
        self.day.text = day
        self.dayType = dayType
        
        switch dayType {
        case .today:
            setupTodayCircleLayer()
        case .workday:
            self.day.textColor = UIColor.SRCalendar.Cell.workday
        case .weekend:
            self.day.textColor = UIColor.SRCalendar.Cell.weekend
        case .workdayUnavaliable:
            self.day.textColor = UIColor.SRCalendar.Cell.workdayWithOpacity
        case .weekendUnavaliable:
            self.day.textColor = UIColor.SRCalendar.Cell.weekendWithOpacity
        case .empty:
            break
        }
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
