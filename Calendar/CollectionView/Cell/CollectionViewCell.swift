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
        
        self.backgroundColor = .red
        day = UILabel(frame: self.contentView.bounds)
        day.textAlignment = .center
        self.addSubview(day)
    }
    
    func setDay(_ day: String) {
        self.day.text = day
    }
}
