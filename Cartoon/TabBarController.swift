//
//  TabBarController.swift
//  Cartoon
//
//  Created by xiangyaguo on 2020/5/3.
//  Copyright © 2020 HiIgor. All rights reserved.
//

import UIKit

class TabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        tabBar.isTranslucent = false
        
        view.backgroundColor = UIColor.background
        let homePageVC = HomeViewController(titles: ["推荐", "VIP", "订阅", "排行"],
                                              vcs: [CTHomeRecommendViewController(),
                                                    CTHomeVIPViewController(),
                                                    CTHomeSubscribeViewController(),
                                                    CTHomeRankViewController()],
                                              pageStyle: .navigationBarSegment)
        addChild("tab_home", "tab_home_S", homePageVC)
        addChild("tab_class", "tab_class_S", CategoryViewController())
        addChild("tab_book", "tab_book_S", BookViewController())
        addChild("tab_mine", "tab_mine_S", MineViewController())
    }
    

    func addChild(_ image: String,
                  _ selectedImage: String,
                  _ viewController: UIViewController) {
        let child = CTNavigationController(rootViewController: viewController)
        child.tabBarItem = UITabBarItem(title: nil, image: UIImage(named: image)?.withRenderingMode(UIImage.RenderingMode.alwaysOriginal), selectedImage: UIImage(named: selectedImage)?.withRenderingMode(UIImage.RenderingMode.alwaysOriginal))
        child.tabBarItem.imageInsets = UIEdgeInsets(top: 6, left: 0, bottom: -6, right: 0)
        addChild(child)
    }
}

extension TabBarController {
    override var preferredStatusBarStyle: UIStatusBarStyle {
        guard let select = selectedViewController else { return .lightContent }
        return select.preferredStatusBarStyle
    }
}
