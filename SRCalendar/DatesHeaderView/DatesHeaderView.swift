//
//  DatesHeaderView.swift
//  SRCalendar
//
//  Created by Antony Yurchenko on 12/4/17.
//  Copyright © 2017 Antony Yurchenko. All rights reserved.
//

import UIKit

protocol DatesHeaderViewDelegate {
    func cancelBtnTouch()
    func acceptBtnTouch()
}

enum TextIds {
    static var fromLabel = "com.calendar.datesHeader.fromLabel"
    static var toLabel = "com.calendar.datesHeader.to"
}

@IBDesignable
class DatesHeaderView: UIView {
    
    @IBOutlet weak var cancelBtn: UIButton!
    @IBOutlet weak var acceptBtn: UIButton!
    
    @IBOutlet weak var fromLabel: UILabel!
    @IBOutlet weak var toLabel: UILabel!
    
    var gradientLayer: CAGradientLayer!
    var translations: [String: String]?
    var delegate: DatesHeaderViewDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupXib()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        setupXib()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        gradientLayer.frame = bounds
    }
    
    private func setupXib() {
        let view = UINib(nibName: "DatesHeaderView", bundle: Bundle(for: type(of: self)))
            .instantiate(withOwner: self, options: nil)[0] as! UIView
        view.frame = bounds
        view.autoresizingMask = [UIViewAutoresizing.flexibleWidth, UIViewAutoresizing.flexibleHeight]
        setupGradientLayer(view, UIColor.SRCalendar.DatesHeader.background)
        addSubview(view)
    }
    
    func setupGradientLayer(_ view: UIView, _ colors: (colors: [CGColor], locations: [NSNumber])) {
        gradientLayer = CAGradientLayer()
        gradientLayer.frame = view.frame
        gradientLayer.colors = colors.colors
        gradientLayer.locations = colors.locations
        gradientLayer.startPoint = CGPoint(x: 0, y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 1, y: 0.5)
        
        view.layer.insertSublayer(gradientLayer, at: 0)
    }

    func setupDates(with selectedIndex: Set<Date>) {
        if selectedIndex.isEmpty {
            fromLabel.text = translations?[TextIds.fromLabel]
            toLabel.text = translations?[TextIds.toLabel]
            return
        }
        if let dateFrom = selectedIndex.min() {
            fromLabel.text = dateFrom.stringRepresentation()
        }
        
        if let dateTo = selectedIndex.max() {
            toLabel.text = dateTo.stringRepresentation()
        }
    }
    
    @IBAction func cancelBtnTouch(_ sender: Any) {
        delegate?.cancelBtnTouch()
    }
    
    @IBAction func acceptBtnTouch(_ sender: Any) {
        delegate?.acceptBtnTouch()
    }
}
