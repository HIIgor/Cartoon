//
//  CTBaseCollectionViewCell.swift
//  Cartoon
//
//  Created by 向亚国 on 2020/5/15.
//  Copyright © 2020 HiIgor. All rights reserved.
//

import UIKit
import Reusable

class CTBaseCollectionViewCell: UICollectionViewCell, Reusable {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    open func setupLayout() {}
}
