//
//  CTBaseTableViewHeaderFooterView.swift
//  Cartoon
//
//  Created by 向亚国 on 2020/5/22.
//  Copyright © 2020 HiIgor. All rights reserved.
//

import UIKit
import Reusable

class CTBaseTableViewHeaderFooterView: UITableViewHeaderFooterView, Reusable {

    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        
        setupLayout()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    open func setupLayout() {}
}
