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
    
    private lazy var flowLayout = PagedFlowLayout(numberOfItemsInRow, numberOfItemsInColumn)
    private lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
    
    private var items = [Item]()
    
    // MARK: - Lifecycle -

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupLayout()
        setupCollectionView()
        setupNavigationItem()
    }
    
    override func viewDidLayoutSubviews() {
        let width = calculateItemWidth()
        let height = calculateItemHeight()
        flowLayout.itemSize = .init(width: width, height: height)
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
        collectionView.dataSource = self
        
        collectionView.backgroundColor = .clear
        collectionView.decelerationRate = .fast
        
        flowLayout.scrollDirection = .horizontal
        flowLayout.minimumInteritemSpacing = itemSpacing
        flowLayout.minimumLineSpacing = itemSpacing
        
        let width = calculateItemWidth()
        let height = calculateItemHeight()
        flowLayout.itemSize = .init(width: width, height: height)
    }
    
    private func setupNavigationItem() {
        navigationItem.title = "SpringBoard"
        
        let addButton = UIBarButtonItem(image: UIImage(systemName: "plus"), style: .plain, target: self, action: #selector(onAddTapped))
        navigationItem.rightBarButtonItem = addButton
        
        let reloadButton = UIBarButtonItem(image: UIImage(systemName: "arrow.clockwise"), style: .plain, target: self, action: #selector(onReloadTapped))
        navigationItem.leftBarButtonItem = reloadButton
    }
    
    @objc private func onAddTapped() {
        items.append(generateRandomItem())
        collectionView.reloadData()
    }
    
    @objc private func onReloadTapped() {
        items = []
        for _ in 1...140 {
            items.append(generateRandomItem())
        }
        collectionView.reloadData()
    }
    
    private func generateRandomItem() -> Item {
        let randomNumber = Int.random(in: 0..<Int.max)
        let url = URL(string: "https://loremflickr.com/200/200?lock=\(randomNumber)")!
        return Item(imageUrl: url)
    }
    
    private func calculateItemWidth() -> CGFloat {
        let totalSpacing = CGFloat(numberOfItemsInRow + 1) * itemSpacing
        return (view.frame.width - totalSpacing) / CGFloat(numberOfItemsInRow)
    }
    
    private func calculateItemHeight() -> CGFloat {
        let totalSpacing = CGFloat(numberOfItemsInColumn - 1) * itemSpacing
        let totalHeight = view.frame.height - view.safeAreaInsets.top - view.safeAreaInsets.bottom - totalSpacing
        return totalHeight / CGFloat(numberOfItemsInColumn)
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
