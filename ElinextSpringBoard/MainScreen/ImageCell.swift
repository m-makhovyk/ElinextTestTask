//
//  ImageCell.swift
//  ElinextSpringBoard
//
//  Created by Mike Makhovyk on 16.02.2021.
//

import UIKit
import Kingfisher

final class ImageCell: UICollectionViewCell {
    
    // MARK: - Public properties -
    
    var item: Item! {
        didSet {
            imageView.kf.setImage(with: item.imageUrl, options: [.processor(processor)])
        }
    }
    
    // MARK: - Private properties -
    
    private let imageView = UIImageView()
    
    private let processor = RoundCornerImageProcessor(cornerRadius: 7)
    
    // MARK: - Lifecycle -
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .lightGray
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Private methods -

extension ImageCell {
    
    private func setupLayout() {
        contentView.addSubview(imageView)
        imageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        imageView.kf.indicatorType = .activity
    }
}
