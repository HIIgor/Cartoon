//
//  CTComicCollectionViewCell.swift
//  Cartoon
//
//  Created by xiangyaguo on 2020/5/14.
//  Copyright © 2020 HiIgor. All rights reserved.
//

import UIKit

enum CTComicCollectionViewCellStyle {
    case none
    case withTitle
    case withTitleAndDesc
}

class CTComicCollectionViewCell: CTBaseCollectionViewCell {
    private lazy var iconView: UIImageView = {
        let iconView = UIImageView()
        iconView.contentMode = .scaleAspectFill
        iconView.clipsToBounds = true
        return iconView
    }()
    
    private lazy var titleLabel: UILabel = {
        let titleLable = UILabel()
        titleLable.textColor = UIColor.black
        titleLable.font = UIFont.systemFont(ofSize: 14)
        return titleLable
    }()
    
    private lazy var descLabel: UILabel = {
        let descLabel = UILabel()
        descLabel.textColor = UIColor.gray
        descLabel.font = UIFont.systemFont(ofSize: 12)
        return descLabel
    }()
    
    override func setupLayout() {
        clipsToBounds = true
        
        contentView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview().inset(UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10))
            make.height.equalTo(25)
            make.bottom.equalToSuperview().offset(-10)
        }
        
        contentView.addSubview(iconView)
        iconView.snp.makeConstraints { make in
            make.top.left.right.equalToSuperview()
            make.bottom.equalTo(titleLabel.snp.top)
        }
        
        contentView.addSubview(descLabel)
        descLabel.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview().inset(UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10))
            make.height.equalTo(20)
            make.top.equalTo(titleLabel.snp.bottom)
        }
    }
    
    var cellStyle: CTComicCollectionViewCellStyle = .withTitle {
        didSet {
            var titleLabelBottomOffset = 0
            var titleLabelHidden = false
            var descLabelHidden = false
            switch cellStyle {
            case .none:
                titleLabelBottomOffset = 25
                titleLabelHidden = true
                descLabelHidden = true
            case .withTitle:
                titleLabelBottomOffset = -10
                titleLabelHidden = false
                descLabelHidden = true
            case .withTitleAndDesc:
                titleLabelBottomOffset = -25
                titleLabelHidden = false
                descLabelHidden = false
            }
            titleLabel.snp.updateConstraints { (make) in
                make.bottom.equalToSuperview().offset(titleLabelBottomOffset)
            }
            titleLabel.isHidden = titleLabelHidden
            descLabel.isHidden = descLabelHidden
        }
    }
    
    var model: CTComicModel? {
        didSet {
            guard let model = model else { return }
            iconView.kf.setImage(urlString: model.cover, placeholder: (bounds.width > bounds.height) ? UIImage(named: "normal_placeholder_h") : UIImage(named: "normal_placeholder_v"))
            titleLabel.text = model.name ?? model.title
            descLabel.text = model.subTitle ?? "更新至\(model.content ?? "0")集"
        }
    }
}
