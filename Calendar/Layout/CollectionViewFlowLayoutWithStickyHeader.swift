//
//  CollectionViewFlowLayoutWithStickyHeader.swift
//  Calendar
//
//  Created by Antony Yurchenko on 11/29/17.
//  Copyright © 2017 Antony Yurchenko. All rights reserved.
//

import UIKit

class CollectionViewFlowLayoutWithStickyHeader: UICollectionViewFlowLayout {
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        let answer = super.layoutAttributesForElements(in: rect)
        
        let contentOffset = collectionView?.contentOffset
        
        for layoutAttributes in answer! {
            if layoutAttributes.representedElementKind == UICollectionElementKindSectionHeader {
                let section = layoutAttributes.indexPath.section
                let numberOfItemsInSection = collectionView!.numberOfItems(inSection: section)
                
                let firstObjectIndexPath = IndexPath.init(item: 0, section: section)
                let lastObjectIndexPath = IndexPath.init(item: max(0, (numberOfItemsInSection - 1)), section: section)
                
                let firstObjectAttrs: UICollectionViewLayoutAttributes!
                let lastObjectAttrs: UICollectionViewLayoutAttributes!
                
                if numberOfItemsInSection > 0 {
                    firstObjectAttrs = self.layoutAttributesForItem(at: firstObjectIndexPath)
                    lastObjectAttrs = self.layoutAttributesForItem(at: lastObjectIndexPath)
                } else {
                    firstObjectAttrs = self.layoutAttributesForSupplementaryView(ofKind: UICollectionElementKindSectionHeader, at: firstObjectIndexPath)
                    lastObjectAttrs = self.layoutAttributesForSupplementaryView(ofKind: UICollectionElementKindSectionFooter, at: lastObjectIndexPath)
                    
                    let headerHeight = layoutAttributes.frame.height
                    var origin = layoutAttributes.frame.origin
                    origin.y = min(max(contentOffset!.y + collectionView!.contentInset.top, firstObjectAttrs.frame.minY - headerHeight),
                                   lastObjectAttrs.frame.maxY - headerHeight)
                    layoutAttributes.zIndex = 1024
                    lastObjectAttrs.frame = CGRect(origin: origin, size: lastObjectAttrs.frame.size)
                }
            }
        }
        
        return answer
    }
}
