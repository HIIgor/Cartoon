//
//  CTUpdateTVTableViewCell.swift
//  Cartoon
//
//  Created by xiangyaguo on 2020/5/18.
//  Copyright © 2020 HiIgor. All rights reserved.
//

import UIKit

class CTUpdateTVTableViewCell: CTBaseTableViewCell {
    
    private lazy var coverView: UIImageView = {
        let cv = UIImageView()
        cv.contentMode = .scaleAspectFill
        cv.layer.cornerRadius = 5
        cv.layer.masksToBounds = true
        return cv
    }()

    private lazy var tipLabel: UILabel = {
        let tip = UILabel()
        tip.backgroundColor = UIColor.black.withAlphaComponent(0.4)
        tip.textColor = UIColor.white
        tip.font = UIFont.systemFont(ofSize: 9)
        return tip
    }()
    
    override func setupLayout() {
        contentView.addSubview(coverView)
        coverView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(UIEdgeInsets(top: 10, left: 10, bottom: 20, right: 10))
        }
        
        coverView.addSubview(tipLabel)
        tipLabel.snp.makeConstraints { make in
            make.left.bottom.right.equalToSuperview()
            make.height.equalTo(20)
        }
        
        let line = UIView().then{
            $0.backgroundColor = UIColor.background
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
            coverView.kf.setImage(urlString: model.cover)
            tipLabel.text = "    \(model.description ?? "")"
        }
    }
}
