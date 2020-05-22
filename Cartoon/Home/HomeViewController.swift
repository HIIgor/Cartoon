//
//  HomeViewController.swift
//  Cartoon
//
//  Created by xiangyaguo on 2020/5/3.
//  Copyright © 2020 HiIgor. All rights reserved.
//

import UIKit

class HomeViewController: CTPageViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func configNavBar() {
        super.configNavBar()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "nav_search"), target: self, action: #selector(searchButtonClick))
    }
    
    @objc private func searchButtonClick() {
        navigationController?.pushViewController(CTSearchViewController(), animated: true)
    }
}
