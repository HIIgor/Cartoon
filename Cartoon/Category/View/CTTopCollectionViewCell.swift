//
//  CTTopCollectionViewCell.swift
//  Cartoon
//
//  Created by xiangyaguo on 2020/5/22.
//  Copyright © 2020 HiIgor. All rights reserved.
//

import UIKit

class CTTopCollectionViewCell: CTBaseCollectionViewCell {
    private lazy var iconView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        return iv
    }()
    
    override func setupLayout() {
        layer.cornerRadius = 5
        layer.borderWidth = 1
        layer.borderColor = UIColor.lightGray.withAlphaComponent(0.5).cgColor
        layer.masksToBounds = true
        
        contentView.addSubview(iconView)
        iconView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    var model: CTTopModel? {
        didSet {
            guard let model = model else { return }
            iconView.kf.setImage(urlString: model.cover)
        }
    }
}
