//
//  CTBaseCollectionReusableView.swift
//  Cartoon
//
//  Created by xiangyaguo on 2020/5/15.
//  Copyright © 2020 HiIgor. All rights reserved.
//

import UIKit
import Reusable

class CTBaseCollectionReusableView: UICollectionReusableView, Reusable {
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    open func setupLayout() {}
}
