//
//  CTSpecialTVTableViewCell.swift
//  Cartoon
//
//  Created by 向亚国 on 2020/5/17.
//  Copyright © 2020 HiIgor. All rights reserved.
//

import UIKit

class CTSpecialTVTableViewCell: CTBaseTableViewCell {
    private lazy var titleLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.textColor = .black
        titleLabel.font = UIFont.systemFont(ofSize: 14)
        return titleLabel
    }()
    
    private lazy var coverView: UIImageView = {
        let cv = UIImageView()
        cv.contentMode = .scaleAspectFill
        cv.layer.cornerRadius = 5
        cv.layer.masksToBounds = true
        return cv
    }()
    
    lazy var tipLabel: UILabel = {
        let tl = UILabel()
        tl.backgroundColor = UIColor.black.withAlphaComponent(0.4)
        tl.textColor = UIColor.white
        tl.font = UIFont.systemFont(ofSize: 9)
        return tl
    }()
    
    override func setupLayout() {
        contentView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.left.top.right.equalToSuperview().inset(UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10))
            make.height.equalTo(40)
        }
        
        contentView.addSubview(coverView)
        coverView.snp.makeConstraints { make in
            make.left.right.bottom.equalToSuperview().inset(UIEdgeInsets(top: 10, left: 10, bottom: 20, right: 10))
            make.top.equalTo(titleLabel.snp.bottom)
        }
        
        coverView.addSubview(tipLabel)
        tipLabel.snp.makeConstraints { make in
            make.left.bottom.right.equalToSuperview()
            make.height.equalTo(20)
        }
        
        let line = UIView().then{ make in
            make.backgroundColor = UIColor.background
        }
        contentView.addSubview(line)
        line.snp.makeConstraints { make in
            make.left.right.bottom.equalToSuperview()
            make.height.equalTo(10)
        }
    }
    
    var model: CTComicModel? {
        didSet {
            guard let model = model else { return }
            titleLabel.text = model.title
            coverView.kf.setImage(urlString: model.cover)
            tipLabel.text = "    \(model.subTitle ?? "")"
        }
    }
}
