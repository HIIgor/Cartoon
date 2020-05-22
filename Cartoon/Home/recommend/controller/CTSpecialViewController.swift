//
//  CTSpecialViewController.swift
//  Cartoon
//
//  Created by xiangyaguo on 2020/5/17.
//  Copyright © 2020 HiIgor. All rights reserved.
//

import UIKit


/// 专题页面
class CTSpecialViewController: CTBaseViewController {
    
    private var page: Int = 1
    private var argCon: Int = 0
    
    private var specialList = [CTComicModel]()
    
    private lazy var tableView: UITableView = {
        let tv = UITableView(frame: CGRect.zero, style: .plain)
        tv.backgroundColor = UIColor.background
        tv.tableFooterView = UIView()
        tv.delegate = self
        tv.dataSource = self
        tv.separatorStyle = .none
        
        tv.register(cellType: CTSpecialTVTableViewCell.self)
        tv.uHead = URefreshHeader { [weak self] in self?.loadData(more: false) }
        tv.uFoot = URefreshFooter { [weak self] in self?.loadData(more: true) }
        tv.uempty = UEmptyView { [weak self] in self?.loadData(more: false) }
        return tv
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        loadData(more: false)
    }
    
    convenience init(argCon: Int = 0) {
        self.init()
        self.argCon = argCon
    }
    
    @objc private func loadData(more: Bool) {
        page = more ? (page + 1) : 1
        ApiLoadingProvider.request(.special(argCon: argCon, page: page), model: CTComicListModel.self) { [weak self] returnData in
            
            self?.tableView.uHead.endRefreshing()
            if returnData?.hasMore == false {
                self?.tableView.uFoot.endRefreshingWithNoMoreData()
            } else {
                self?.tableView.uFoot.endRefreshing()
            }
            self?.tableView.uempty?.allowShow = true
            
            if !more { self?.specialList.removeAll() }
            self?.specialList.append(contentsOf: returnData?.comics ?? [])
            self?.tableView.reloadData()
            
            guard let defaultParams = returnData?.defaultParameters else { return }
            self?.argCon = defaultParams.defaultArgCon
        }
    }
    
    override func setupLayout() {
        view.addSubview(tableView)
        tableView.frame = view.bounds
    }
    

}

extension CTSpecialViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return specialList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(for: indexPath, cellType: CTSpecialTVTableViewCell.self)
        cell.model = specialList[indexPath.row]
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = specialList[indexPath.row]
        var html: String?
        if item.specialType == 1 {
            html = "http://www.u17.com/z/zt/appspecial/special_comic_list_v3.html"
        } else if item.specialType == 2{
            html = "http://www.u17.com/z/zt/appspecial/special_comic_list_new.html"
        }
        guard let host = html else { return }
        let path = "special_id=\(item.specialId)&is_comment=\(item.isComment)"
        let url = [host, path].joined(separator: "?")
        let vc = CTWebViewController(url: url)
        navigationController?.pushViewController(vc, animated: true)
    }
}














