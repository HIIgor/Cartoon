//
//  TabBarController.swift
//  Cartoon
//
//  Created by 向亚国 on 2020/5/3.
//  Copyright © 2020 HiIgor. All rights reserved.
//

import UIKit

class TabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor.background
        addChild("tab_home", "tab_home_S", HomeViewController.self)
        addChild("tab_class", "tab_class_S", CategoryViewController.self)
        addChild("tab_book", "tab_book_S", BookViewController.self)
        addChild("tab_mine", "tab_mine_S", MineViewController.self)
    }
    

    func addChild(_ image: String,
                  _ selectedImage: String,
                  _ vcType: UIViewController.Type) {
        let child = UINavigationController(rootViewController: vcType.init())
        child.tabBarItem = UITabBarItem(title: nil, image: UIImage(named: image)?.withRenderingMode(UIImage.RenderingMode.alwaysOriginal), selectedImage: UIImage(named: selectedImage)?.withRenderingMode(UIImage.RenderingMode.alwaysOriginal))
        child.tabBarItem.imageInsets = UIEdgeInsets(top: 6, left: 0, bottom: -6, right: 0)
        addChild(child)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
