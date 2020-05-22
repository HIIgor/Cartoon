//
//  CTSearchHeaderView.swift
//  Cartoon
//
//  Created by 向亚国 on 2020/5/22.
//  Copyright © 2020 HiIgor. All rights reserved.
//

import UIKit

typealias CTSearchHeaderMoreActionClosure = () -> Void

protocol CTSearchHeaderViewDelegate: class {
    func searchHeaderView(_ searchHeader: CTSearchHeaderView, moreAction button: UIButton)
}

class CTSearchHeaderView: CTBaseTableViewHeaderFooterView {

    weak var delegate: CTSearchHeaderViewDelegate?
    
    private var moreActionClosure: CTSearchHeaderMoreActionClosure?
    
    lazy var titleLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.font = UIFont.systemFont(ofSize: 14)
        titleLabel.textColor = UIColor.gray
        return titleLabel
    }()
    
    lazy var moreButton: UIButton = {
        let moreButton = UIButton(type: .custom)
        moreButton.setTitleColor(UIColor.lightGray, for: .normal)
        moreButton.addTarget(self, action: #selector(moreAction), for: .touchUpInside)
        return moreButton
    }()
    
    @objc private func moreAction(button: UIButton) {
        delegate?.searchHeaderView(self, moreAction: button)
        
        guard let closure = moreActionClosure else { return }
        closure()
    }
    
    func setMoreActionClosure(_ closure: @escaping CTSearchHeaderMoreActionClosure) {
        moreActionClosure = closure
    }
    
    override func setupLayout() {
        contentView.backgroundColor = UIColor.white
        contentView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(10)
            make.top.bottom.equalToSuperview()
            make.width.equalTo(200)
        }
        
        contentView.addSubview(moreButton)
        moreButton.snp.makeConstraints { make in
            make.top.right.bottom.equalToSuperview()
            make.width.equalTo(40)
        }
        
        let line = UIView().then { $0.backgroundColor = UIColor.background }
        contentView.addSubview(line)
        line.snp.makeConstraints { make in
            make.left.right.bottom.equalToSuperview()
            make.height.equalTo(1)
        }
    }
}
