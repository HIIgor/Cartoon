//
//  CTWebViewController.swift
//  Cartoon
//
//  Created by xiangyaguo on 2020/5/16.
//  Copyright © 2020 HiIgor. All rights reserved.
//

import UIKit
import WebKit

class CTWebViewController: CTBaseViewController {

    var request: URLRequest!
    
    lazy var webView: WKWebView = {
        let wv = WKWebView()
        wv.allowsBackForwardNavigationGestures = true
        wv.navigationDelegate = self
        wv.uiDelegate = self
        return wv
    }()
    
    lazy var progressView: UIProgressView = {
        let pv = UIProgressView()
        pv.trackImage = UIImage(named: "nav_bg")
        pv.progressTintColor = .white
        return pv
    }()
    
    convenience init (url: String?) {
        self.init()
        self.request = URLRequest(url: URL(string: url ?? "")!)
    }
    
    deinit {
        webView.removeObserver(self, forKeyPath: "estimatedProgress")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        webView.addObserver(self, forKeyPath: "estimatedProgress", options: .new, context: nil)
        webView.load(request)
    }
    
    override func setupLayout() {
        view.addSubview(webView)
        
        webView.snp.makeConstraints { (make) in
            make.edges.equalTo(self.view.usnp.edges)
        }
        
        view.addSubview(progressView)
        progressView.snp.makeConstraints { (make) in
            make.left.top.right.equalToSuperview()
            make.height.equalTo(2)
        }
    }
    
    override func configNavBar() {
        super.configNavBar()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "nav_reload"),
                                                            target: self, action: #selector(reload))
    }
    
    @objc func reload() {
        webView.reload()
    }
    
    override func pressBack() {
        if webView.canGoBack {
            webView.goBack()
        } else {
            navigationController?.popViewController(animated: true)
        }
    }
}

extension CTWebViewController: WKNavigationDelegate, WKUIDelegate {
    override func observeValue(forKeyPath keyPath: String?,
                               of object: Any?,
                               change: [NSKeyValueChangeKey : Any]?,
                               context: UnsafeMutableRawPointer?) {
        if (keyPath == "estimatedProgress") {
            progressView.isHidden = webView.estimatedProgress >= 1
            progressView.setProgress(Float(webView.estimatedProgress), animated: true)
        }
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        
        progressView.setProgress(0.0, animated: false)
        navigationItem.title = title ?? (webView.title ?? webView.url?.host)
    }
}
