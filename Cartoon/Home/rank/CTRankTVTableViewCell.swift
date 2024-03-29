//
//  CTTVTableViewCell.swift
//  Cartoon
//
//  Created by xiangyaguo on 2020/5/21.
//  Copyright © 2020 HiIgor. All rights reserved.
//

import UIKit

class CTRankTVTableViewCell: CTBaseTableViewCell {
    
    lazy var iconView: UIImageView = {
        let iconView = UIImageView()
        iconView.contentMode = .scaleAspectFill
        iconView.clipsToBounds = true
        return iconView
    }()
    
    lazy var titleLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.textColor = UIColor.black
        titleLabel.font = UIFont.systemFont(ofSize: 18)
        return titleLabel
    }()
    
    lazy var descLabel: UILabel = {
        let descLabel = UILabel()
        descLabel.textColor = UIColor.gray
        descLabel.numberOfLines = 0
        descLabel.font = UIFont.systemFont(ofSize: 14)
        return descLabel
    }()
    
    
    override func setupLayout() {
        let line = UIView().then{
            $0.backgroundColor = UIColor.background
        }
        contentView.addSubview(line)
        line.snp.makeConstraints{ make in
            make.left.bottom.right.equalToSuperview()
            make.height.equalTo(10)
        }
        
        contentView.addSubview(iconView)
        iconView.snp.makeConstraints { make in
            make.left.top.equalToSuperview().offset(10)
            make.bottom.equalTo(line.snp.top).offset(-10)
            make.width.equalToSuperview().multipliedBy(0.5)
        }
        
        contentView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.left.equalTo(iconView.snp.right).offset(10)
            make.right.equalToSuperview().offset(-10)
            make.height.equalTo(30)
            make.top.equalTo(iconView).offset(20)
        }
        
        contentView.addSubview(descLabel)
        descLabel.snp.makeConstraints { make in
            make.left.equalTo(iconView.snp.right).offset(10)
            make.right.equalToSuperview().offset(-10)
            make.top.equalTo(titleLabel.snp.bottom).offset(10)
            make.bottom.equalTo(iconView)
        }
    }
    
    var model: CTRankingModel? {
        didSet {
            guard let model = model else { return }
            iconView.kf.setImage(urlString: model.cover)
            titleLabel.text = "\(model.title ?? "")"
            descLabel.text = model.subTitle
        }
    }

}
