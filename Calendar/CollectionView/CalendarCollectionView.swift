//
//  CalendarCollectionView.swift
//  Calendar
//
//  Created by Antony Yurchenko on 11/29/17.
//  Copyright © 2017 Antony Yurchenko. All rights reserved.
//

import UIKit

let collectionViewCellId = "CollectionViewCell"
let monthHeaderViewId = "MonthHeaderView"

class CalendarCollectionView: UICollectionView {
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)
        
        setup()
    }
    
    func setup() {
        backgroundColor = UIColor.white
        showsVerticalScrollIndicator = false
        showsHorizontalScrollIndicator = false
        
        register(CollectionViewCell.self, forCellWithReuseIdentifier: collectionViewCellId)
        register(MonthHeaderView.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: monthHeaderViewId)
        
        isPagingEnabled = false
    }
    
    override func setCollectionViewLayout(_ layout: UICollectionViewLayout, animated: Bool) {
        isPagingEnabled = false
        super.setCollectionViewLayout(layout, animated: animated)
    }
    
    override func setCollectionViewLayout(_ layout: UICollectionViewLayout, animated: Bool, completion: ((Bool) -> Void)? = nil) {
        isPagingEnabled = false
        super.setCollectionViewLayout(layout, animated: animated, completion: completion)
    }
}
