//
//  PagedFlowLayout.swift
//  ElinextSpringBoard
//
//  Created by Mike Makhovyk on 16.02.2021.
//

import UIKit

final class PagedFlowLayout: UICollectionViewFlowLayout {
    
    private let numberOfItemsInRow: Int
    
    init(numberOfItemsInRow: Int) {
        self.numberOfItemsInRow = numberOfItemsInRow
        super.init()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func targetContentOffset(
        forProposedContentOffset proposedContentOffset: CGPoint,
        withScrollingVelocity velocity: CGPoint
    ) -> CGPoint {
        guard let collectionView = collectionView else {
            return super.targetContentOffset(forProposedContentOffset: proposedContentOffset, withScrollingVelocity: velocity)
        }
        
        let pageWidth = (itemSize.width + minimumInteritemSpacing) * CGFloat(numberOfItemsInRow)
        let approximatePage = collectionView.contentOffset.x / pageWidth

        let currentPage = velocity.x == 0 ? round(approximatePage) : (velocity.x < 0.0 ? floor(approximatePage) : ceil(approximatePage))
        let newHorizontalOffset = (currentPage * pageWidth) - collectionView.contentInset.left

        return CGPoint(x: newHorizontalOffset, y: proposedContentOffset.y)
    }
}
