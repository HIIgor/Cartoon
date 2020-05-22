//
//  CTComicViewController.swift
//  Cartoon
//
//  Created by xiangyaguo on 2020/5/18.
//  Copyright © 2020 HiIgor. All rights reserved.
//

import UIKit

protocol CTComicViewWillEndDragginDelegate: class {
    func comicWillEndDragging(_ scrollView: UIScrollView)
}

class CTComicViewController: CTBaseViewController {

    private var comicid: Int = 0
    
    lazy var mainScrollView: UIScrollView = {
        let ms = UIScrollView()
        ms.delegate = self
        return ms
    }()
    
    convenience init(comicid: Int) {
        self.init()
        self.comicid = comicid
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
}

extension CTComicViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
    }
    
    
}
