//
//  MonthCollectionViewLayout.swift
//  Calendar
//
//  Created by Antony Yurchenko on 11/29/17.
//  Copyright © 2017 Antony Yurchenko. All rights reserved.
//

import UIKit

class MonthCollectionViewLayout: UICollectionViewFlowLayout {
    
    let MonthCollectionViewLayoutCell = "MonthCollectionViewLayoutCell"
    let MonthCollectionViewLayoutHeader = "MonthCollectionViewLayoutHeader"
    
    var layoutInfo: [String: [IndexPath: UICollectionViewLayoutAttributes]]!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func setupWidth(_ width: CGFloat) {
        self.headerReferenceSize = CGSize(width: width, height: 64)
        
        let minSpacingWidth: CGFloat = 0
        let maxWidth: CGFloat = floor((width - minSpacingWidth * 6) / 7)
        self.itemSize = CGSize(width: maxWidth, height: maxWidth)
        self.minimumLineSpacing = 0
        self.minimumInteritemSpacing = 0
    }
    
    override init() {
        super.init()
        
        self.scrollDirection = .vertical
        self.headerReferenceSize = CGSize(width: 320, height: 64)
        self.itemSize = CGSize(width: 44, height: 44)
        self.minimumLineSpacing = 2
        self.minimumInteritemSpacing = 2
    }
    
    override func prepare() {
        super.prepare()
        
        var newLayoutInfo = [String :[IndexPath: UICollectionViewLayoutAttributes]]()
        var cellLayoutInfo = [IndexPath: UICollectionViewLayoutAttributes]()
        var headerLayoutInfo = [IndexPath: UICollectionViewLayoutAttributes]()
        
        let sectionCount = self.collectionView!.numberOfSections
        var indexPath: IndexPath!
        var previousRect = CGRect.zero
        var previousIndexPath: IndexPath?
        
        for section in 0..<sectionCount {
            let itemCount = self.collectionView!.numberOfItems(inSection: section)
            indexPath = IndexPath.init(item: 0, section: section)
            let itemAttributes = UICollectionViewLayoutAttributes(forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, with: indexPath)
            itemAttributes.frame = self.frameForHeaderAtSection(section: indexPath.section, previousRect: previousRect)
            headerLayoutInfo[indexPath] = itemAttributes
            
            for item in 0..<itemCount {
                indexPath = IndexPath.init(item: item, section: section)
                
                let itemAttributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
                itemAttributes.frame = self.frameForItemAtIndexPath(indexPath: indexPath, previousRect: previousRect, previousIndexPath: previousIndexPath)
                previousRect = itemAttributes.frame
                cellLayoutInfo[indexPath] = itemAttributes
                previousIndexPath = indexPath
            }
        }
        
        newLayoutInfo[MonthCollectionViewLayoutCell] = cellLayoutInfo
        newLayoutInfo[MonthCollectionViewLayoutHeader] = headerLayoutInfo
        
        self.layoutInfo = newLayoutInfo
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        var allAttributes = [UICollectionViewLayoutAttributes]()
        
        for layout in layoutInfo {
            for attributes in layout.value {
                if rect.intersects(attributes.value.frame) {
                    allAttributes.append(attributes.value)
                }
            }
        }
        
        return allAttributes
    }
    
    override var collectionViewContentSize: CGSize {
        let numOfSections = self.collectionView!.dataSource!.numberOfSections!(in: self.collectionView!)
        let lastHeaderIndexPath = IndexPath.init(item: 0, section: numOfSections - 1)
        let lastLayoutAttributes = self.layoutAttributesForSupplementaryView(ofKind: UICollectionElementKindSectionHeader, at: lastHeaderIndexPath)
        let contentSize = CGSize(width: lastLayoutAttributes!.frame.maxX, height: lastLayoutAttributes!.frame.maxY + 6 * self.itemSize.height)
        return contentSize
    }
    
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        return self.layoutInfo[MonthCollectionViewLayoutCell]?[indexPath]
    }
    
    func frameForItemAtIndexPath(indexPath: IndexPath, previousRect: CGRect, previousIndexPath: IndexPath?) -> CGRect {
        if previousRect == .zero {
            return CGRect(x: 0, y: self.headerReferenceSize.height + self.minimumLineSpacing, width: self.itemSize.width, height: self.itemSize.height)
        } else {
            var theoricalRect = previousRect
            theoricalRect.origin.x = theoricalRect.origin.x + self.minimumLineSpacing + self.itemSize.width
            if (indexPath.section - previousIndexPath!.section) > 0 {
                theoricalRect.origin.y = theoricalRect.origin.y + self.itemSize.height + self.headerReferenceSize.height + self.minimumLineSpacing
                theoricalRect.origin.x = 0
            } else if (theoricalRect.origin.x + self.itemSize.width) > self.collectionView!.frame.size.width {
                theoricalRect.origin.x = 0
                theoricalRect.origin.y = theoricalRect.origin.y + self.minimumLineSpacing + self.itemSize.height
            }
            
            return theoricalRect
        }
    }
    
    override func layoutAttributesForSupplementaryView(ofKind elementKind: String, at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        return self.layoutInfo[MonthCollectionViewLayoutHeader]?[indexPath]
    }
    
    func frameForHeaderAtSection(section: Int, previousRect: CGRect) -> CGRect {
        if previousRect == .zero {
            return CGRect(x: 0, y: 0, width: self.headerReferenceSize.width, height: self.headerReferenceSize.height)
        } else {
            var theoricalRect = previousRect
            theoricalRect.origin.x = 0
            theoricalRect.origin.y = theoricalRect.origin.y + self.itemSize.height + self.minimumLineSpacing
            theoricalRect.size.width = self.headerReferenceSize.width
            theoricalRect.size.height = self.headerReferenceSize.height
            return theoricalRect
        }
    }
}
