//
//  ViewController.swift
//  ElinextSpringBoard
//
//  Created by Mike Makhovyk on 16.02.2021.
//

import UIKit
import SnapKit

final class MainViewController: UIViewController {
    
    // MARK: - Private propertiess -
    
    private let numberOfItemsInRow = 7
    private let numberOfItemsInColumn = 10
    private let itemSpacing: CGFloat = 2
    
    private lazy var flowLayout = PagedFlowLayout(numberOfItemsInRow: numberOfItemsInRow)
    private lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
    
    private var items = [Item]()
    
    // MARK: - Lifecycle -

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupLayout()
        setupCollectionView()
        generateItems()
    }
}

// MARK: - Private methods -

extension MainViewController {
    
    private func setupLayout() {
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(itemSpacing)
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
        }
        
        view.backgroundColor = .white
    }
    
    private func setupCollectionView() {
        collectionView.register(ImageCell.self, forCellWithReuseIdentifier: ImageCell.className)
        collectionView.delegate = self
        collectionView.dataSource = self
        
        collectionView.backgroundColor = .red
        collectionView.decelerationRate = .fast
        
        flowLayout.scrollDirection = .horizontal
        flowLayout.minimumInteritemSpacing = itemSpacing
        flowLayout.minimumLineSpacing = itemSpacing
        
        let width = calculateItemWidth()
        let height = calculateItemHeight()
        flowLayout.itemSize = .init(width: width, height: height)
    }
    
    private func generateItems() {
        for index in 1...350 {
            let url = URL(string: "https://loremflickr.com/200/200?lock=\(index)")!
            items.append(Item(imageUrl: url))
        }
        collectionView.reloadData()
    }
}

// MARK: - CollectionView DataSource -

extension MainViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ImageCell.className, for: indexPath) as! ImageCell
        let item = items[indexPath.item]
        cell.item = item
        return cell
    }
}

// MARK: - CollectionView Delegate

extension MainViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        let width = calculateItemWidth()
        let height = calculateItemHeight()
        return .init(width: width, height: height)
    }
    
    private func calculateItemWidth() -> CGFloat {
        let totalSpacing = CGFloat(numberOfItemsInRow + 1) * itemSpacing
        return (view.frame.width - totalSpacing) / CGFloat(numberOfItemsInRow)
    }
    
    private func calculateItemHeight() -> CGFloat {
        let totalSpacing = CGFloat(numberOfItemsInColumn) * itemSpacing
        let totalHeight = view.frame.height - view.safeAreaInsets.top - view.safeAreaInsets.bottom - totalSpacing
        return totalHeight / CGFloat(numberOfItemsInColumn)
    }
}
