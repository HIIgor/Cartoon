//
//  CTBaseTableViewCell.swift
//  Cartoon
//
//  Created by xiangyaguo on 2020/5/17.
//  Copyright © 2020 HiIgor. All rights reserved.
//

import UIKit
import Reusable

class CTBaseTableViewCell: UITableViewCell, Reusable {

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    open func setupLayout() {}
}
