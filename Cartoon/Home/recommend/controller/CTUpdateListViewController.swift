//
//  CTUpdateListViewController.swift
//  Cartoon
//
//  Created by 向亚国 on 2020/5/17.
//  Copyright © 2020 HiIgor. All rights reserved.
//

import UIKit

class CTUpdateListViewController: CTBaseViewController {
    private var argCon: Int = 0
    private var argName: String?
    private var argValue: Int = 0
    private var page: Int = 1
    
    private var comicList = [CTComicModel]()
    private var spinnerName: String = ""
    
    lazy var tableView: UITableView = {
        let tv = UITableView(frame: .zero, style: .plain)
        tv.tableFooterView = UIView()
        tv.backgroundColor = UIColor.background
        tv.delegate = self
        tv.dataSource = self
        
        tv.register(cellType: CTUpdateTVTableViewCell.self)
        tv.uHead = URefreshHeader { [weak self] in self?.loadData(more: false) }
        tv.uFoot = URefreshFooter { [weak self] in self?.loadData(more: true) }
        tv.uempty = UEmptyView { [weak self] in self?.loadData(more: false) }
        return tv
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        loadData(more: false)
    }
    
    convenience init(argCon: Int = 0, argName: String?, argValue: Int = 0) {
        self.init()
        self.argCon = argCon
        self.argName = argName
        self.argValue = argValue
    }
    
    @objc private func loadData(more: Bool) {
        page = more ? (page + 1) : page
        ApiLoadingProvider.request(.comicList(argCon: argCon, argName: argName ?? "", argValue: argValue, page: page), model: CTComicListModel.self) { [weak self] returnData in
            self?.tableView.uHead.endRefreshing()
            if returnData?.hasMore == false {
                self?.tableView.uFoot.endRefreshingWithNoMoreData()
            } else {
                self?.tableView.uFoot.endRefreshing()
            }
            self?.tableView.uempty?.allowShow = true
            
            if more == false { self?.comicList.removeAll() }
            self?.comicList.append(contentsOf: returnData?.comics ?? [])
            self?.tableView.reloadData()
            
            guard let defaultParams = returnData?.defaultParameters else { return }
            self?.argCon = defaultParams.defaultArgCon
            guard let defaultConTagType = defaultParams.defaultConTagType else { return }
            self?.spinnerName = defaultConTagType
        }
    }
    
    override func setupLayout() {
        view.addSubview(tableView)
        tableView.frame = view.bounds
    }

}

extension CTUpdateListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return comicList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(for: indexPath, cellType: CTUpdateTVTableViewCell.self)
        cell.model = comicList[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 180
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = CTBaseViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
}
