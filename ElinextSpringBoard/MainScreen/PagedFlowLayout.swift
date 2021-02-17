//
//  PagedFlowLayout.swift
//  ElinextSpringBoard
//
//  Created by Mike Makhovyk on 16.02.2021.
//

import UIKit

final class PagedFlowLayout: UICollectionViewFlowLayout {
    
    // MARK: - Private properties -
    
    private let numberOfItemsInRow: Int
    private let numberOfItemsInColumn: Int
    
    private var cellCount = 0
    private var boundsSize = CGSize.zero
    
    // MARK: - Lifecycle -
    
    init(_ numberOfItemsInRow: Int, _ numberOfItemsInColumn: Int) {
        self.numberOfItemsInRow = numberOfItemsInRow
        self.numberOfItemsInColumn = numberOfItemsInColumn
        super.init()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override var itemSize: CGSize {
        didSet {
            invalidateLayout()
        }
    }
    
    public override func prepare() {
        cellCount = collectionView?.numberOfItems(inSection: 0) ?? 0
        boundsSize = collectionView?.bounds.size ?? .zero
    }
    
    public override var collectionViewContentSize: CGSize {
        let itemsPerPage = numberOfItemsInColumn * numberOfItemsInRow
        let numberOfPages = Int(ceil(Double(cellCount) / Double(itemsPerPage)))
        
        var size = boundsSize
        size.width = CGFloat(numberOfPages) * boundsSize.width
        return size
    }
    
    public override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        if cellCount == 0 {
            return []
        }
        
        var allAttributes = [UICollectionViewLayoutAttributes]()
        for i in 0...(cellCount - 1) {
            let indexPath = IndexPath(row: i, section: 0)
            let attr = computeLayoutAttributesForCellAt(indexPath: indexPath)
            allAttributes.append(attr)
        }
        return allAttributes
    }
    
    public override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        return computeLayoutAttributesForCellAt(indexPath: indexPath)
    }
    
    public override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        return true
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

// MARK: - Private methods -

extension PagedFlowLayout {
    
    private func computeLayoutAttributesForCellAt(indexPath:IndexPath) -> UICollectionViewLayoutAttributes {
        let row = indexPath.row
        let bounds = collectionView?.bounds ?? .zero
        
        let itemsPerPage = numberOfItemsInColumn * numberOfItemsInRow
        
        let columnPosition = row % numberOfItemsInRow
        let rowPosition = (row / numberOfItemsInRow) % numberOfItemsInColumn
        let itemPage = Int(floor(Double(row)/Double(itemsPerPage)))
        
        let attr = UICollectionViewLayoutAttributes(forCellWith: indexPath)
        
        var frame = CGRect.zero
        frame.origin.x = CGFloat(itemPage) * bounds.size.width + CGFloat(columnPosition) * (itemSize.width + minimumInteritemSpacing)
        frame.origin.y = CGFloat(rowPosition) * (itemSize.height + minimumLineSpacing)
        frame.size = itemSize
        attr.frame = frame
        return attr
    }
}
