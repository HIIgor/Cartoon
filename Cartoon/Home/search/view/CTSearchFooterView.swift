//
//  CTSearchFooterView.swift
//  Cartoon
//
//  Created by 向亚国 on 2020/5/22.
//  Copyright © 2020 HiIgor. All rights reserved.
//

import UIKit


class CTSearchCollectionViewCell: CTBaseCollectionViewCell {
    lazy var titleLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.textAlignment = .center
        titleLabel.font = UIFont.systemFont(ofSize: 14)
        titleLabel.textColor = UIColor.darkGray
        return titleLabel
    }()
    
    override func setupLayout() {
        layer.borderWidth = 1
        layer.borderColor = UIColor.background.cgColor
        
        contentView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { (make) in
            make.edges.equalToSuperview().inset(UIEdgeInsets(top: 10, left: 20, bottom: 10, right: 20))
        }
    }
}

typealias CTSearchFooterDidSelectIndexClosure = (_ index: Int, _ model: CTSearchItemModel) -> Void

protocol CTSearchFooterViewDelegate: class {
    func searchFooterView(_ searchFooter: CTSearchFooterView, didSelectAt index: Int, _ model: CTSearchItemModel)
}

class CTSearchFooterView: CTBaseTableViewHeaderFooterView {

    weak var delegate: CTSearchFooterViewDelegate?
    private var didSelectIndexClosure: CTSearchFooterDidSelectIndexClosure?
    
    private lazy var collectionView: UICollectionView = {
        let layout = UCollectionViewAlignedLayout()
        layout.minimumInteritemSpacing = 10
        layout.minimumLineSpacing = 10
        layout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        layout.horizontalAlignment = .left
        layout.estimatedItemSize = CGSize(width: 100, height: 40)
        let collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        collectionView.backgroundColor = UIColor.white
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(cellType: CTSearchCollectionViewCell.self)
        return collectionView
    }()
    
    var data: [CTSearchItemModel] = [] {
        didSet {
            collectionView.reloadData()
        }
    }
    
    override func setupLayout() {
        contentView.backgroundColor = UIColor.white
        contentView.addSubview(collectionView)
        contentView.frame = bounds
    }
    
}

extension CTSearchFooterView: UICollectionViewDataSource, UICollectionViewDelegate {
        func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
            return data.count
        }
        
        func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
            let cell = collectionView.dequeueReusableCell(for: indexPath, cellType: CTSearchCollectionViewCell.self)
            cell.layer.cornerRadius = cell.bounds.height * 0.5
            cell.titleLabel.text = data[indexPath.row].name
            return cell
        }
        
        func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
            delegate?.searchFooterView(self, didSelectAt: indexPath.row, data[indexPath.row] )
            
            guard let closure = didSelectIndexClosure else { return }
            closure(indexPath.row, data[indexPath.row])
        }
        
        func didSelectIndexClosure(_ closure: @escaping CTSearchFooterDidSelectIndexClosure) {
            didSelectIndexClosure = closure
        }
}
