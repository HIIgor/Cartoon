//
//  CTBaseViewController.swift
//  Cartoon
//
//  Created by xiangyaguo on 2020/5/13.
//  Copyright © 2020 HiIgor. All rights reserved.
//

import UIKit

class CTBaseViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor.background
        
        if #available(iOS 11.0 , *) {
            UIScrollView.appearance().contentInsetAdjustmentBehavior = .never
        } else {
            automaticallyAdjustsScrollViewInsets = false
        }
        
        setupLayout()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        configNavBar()
    }
    
    //    abstract func
    func setupLayout () {}
    
    func configNavBar () {
        guard let nav = navigationController as? CTNavigationController else { return }
        if nav.visibleViewController == self {
            nav.setBarStyle(.theme)
            nav.disablePopGesture = false
            nav.setNavigationBarHidden(false, animated: true)
            if nav.viewControllers.count > 1 {
                navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "nav_back_white"),
                                                                   target: self,
                                                                   action: #selector(pressBack))
            }
        }
    }
    
    @objc func pressBack () {
        navigationController?.popViewController(animated: true)
    }
}

extension CTBaseViewController {
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
}
