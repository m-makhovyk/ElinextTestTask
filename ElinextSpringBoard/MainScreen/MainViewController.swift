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
    
    private let flowLayout = UICollectionViewFlowLayout()
    private lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
    
    private let numberOfItemsInRow = 7
    private let numberOfItemsInColumn = 10
    private let itemSpacing = 2
    
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
            make.edges.equalToSuperview().inset(itemSpacing)
        }
        
        view.backgroundColor = .white
    }
    
    private func setupCollectionView() {
        collectionView.register(ImageCell.self, forCellWithReuseIdentifier: ImageCell.className)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = .clear
    }
    
    private func generateItems() {
        for index in 1...140 {
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
        let width = (collectionView.bounds.width - CGFloat((numberOfItemsInRow - 1) * itemSpacing)) / CGFloat(numberOfItemsInRow)
        let height = (collectionView.bounds.height - CGFloat((numberOfItemsInColumn - 1) * itemSpacing)) / CGFloat(numberOfItemsInColumn)
        return .init(width: width, height: height)
    }
}
