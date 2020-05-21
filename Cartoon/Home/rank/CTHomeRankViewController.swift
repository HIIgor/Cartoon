//
//  CTHomeRankViewController.swift
//  Cartoon
//
//  Created by 向亚国 on 2020/5/21.
//  Copyright © 2020 HiIgor. All rights reserved.
//

import UIKit

class CTHomeRankViewController: CTBaseViewController {
    private var rankList = [CTRankingModel]()
    
    lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.backgroundColor = UIColor.background
        tableView.tableFooterView = UIView()
        tableView.separatorStyle = .none
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.register(cellType: CTRankTVTableViewCell.self)
        tableView.uHead = URefreshHeader{ [weak self] in self?.setupLoadData() }
        tableView.uempty = UEmptyView { [weak self] in self?.setupLoadData() }
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupLoadData()
    }
    
    override func setupLayout() {
        view.addSubview(tableView)
        tableView.frame = view.bounds
    }
    
    @objc private func setupLoadData() {
        ApiLoadingProvider.request(.rankList, model: CTRankinglistModel.self) { (returnData) in
            self.tableView.uHead.endRefreshing()
            self.tableView.uempty?.allowShow = true
            
            self.rankList = returnData?.rankinglist ?? []
            self.tableView.reloadData()
        }
    }
}

extension CTHomeRankViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return rankList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(for: indexPath, cellType: CTRankTVTableViewCell.self)
        cell.model = rankList[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return screenWidth * 0.4
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let model = rankList[indexPath.row]
        let vc = CTComicListViewController(argCon: model.argCon,
                                          argName: model.argName,
                                          argValue: model.argValue)
        vc.title = "\(model.title!)榜"
        navigationController?.pushViewController(vc, animated: true)
    }

}
