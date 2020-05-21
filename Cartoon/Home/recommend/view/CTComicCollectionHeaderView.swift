//
//  CTComicCollectionHeaderView.swift
//  Cartoon
//
//  Created by 向亚国 on 2020/5/15.
//  Copyright © 2020 HiIgor. All rights reserved.
//

import UIKit

typealias CTComicCollectionViewHeaderMoreActionClosure = () -> Void

protocol CTComicCollectionHeaderViewDelegate: class {
    func comcCollectionViewHeaderView(_ comicCHeader: CTComicCollectionHeaderView, moreAction button: UIButton)
}

class CTComicCollectionHeaderView: CTBaseCollectionReusableView {
    weak var delegate: CTComicCollectionHeaderViewDelegate?
    private var moreActionClosure: CTComicCollectionViewHeaderMoreActionClosure?
    
    lazy var iconView: UIImageView = {
        return UIImageView()
    }()
    
    lazy var titleLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.font = UIFont.systemFont(ofSize: 14)
        titleLabel.textColor = .black
        return titleLabel
    }()
    
    lazy var moreButton: UIButton = {
        let m = UIButton(type: .system)
        m.setTitle("•••", for: .normal)
        m.setTitleColor(UIColor.lightGray, for: .normal)
        m.titleLabel?.font = UIFont.systemFont(ofSize: 12)
        m.addTarget(self, action: #selector(moreActionClick), for: .touchUpInside)
        return m
    }()
    
    @objc func moreActionClick(button: UIButton) {
        delegate?.comcCollectionViewHeaderView(self, moreAction: button)
        
        guard let closure = moreActionClosure else { return }
        closure()
    }
    
    func setMoreActionClosure(_ closure: CTComicCollectionViewHeaderMoreActionClosure?) {
        moreActionClosure = closure
    }
    
    override func setupLayout() {
        addSubview(iconView)
        iconView.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(5)
            make.centerY.equalToSuperview()
            make.width.height.equalTo(40)
        }
        
        addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.left.equalTo(iconView.snp.right).offset(5)
            make.centerY.height.equalTo(iconView)
            make.width.equalTo(200)
        }
        
        addSubview(moreButton)
        moreButton.snp.makeConstraints { make in
            make.top.right.bottom.equalToSuperview()
            make.width.equalTo(40)
        }
    }
}
