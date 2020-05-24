//
//  BookselfViewController.swift
//  Cartoon
//
//  Created by xiangyaguo on 2020/5/3.
//  Copyright © 2020 HiIgor. All rights reserved.
//

import UIKit

class BookViewController: CTPageViewController {
    private var topList = [CTTopModel]()
    private var rankList = [CTRankingModel]()
    
    private lazy var collectionView: UICollectionView = {
        let lt = UICollectionViewFlowLayout()
        lt.minimumInteritemSpacing = 10
        lt.minimumLineSpacing = 10
        let collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: lt)
        collectionView.backgroundColor = UIColor.white
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.alwaysBounceVertical = true
        collectionView.register(cellType: CTRankCollectionViewCell.self)
        collectionView.register(cellType: CTTopCollectionViewCell.self)
        collectionView.uHead = URefreshHeader { [weak self] in self?.setupLoadData() }
        collectionView.uempty = UEmptyView { [weak self] in self?.setupLoadData() }
        return collectionView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
    }
    
    private func setupLoadData() {
        ApiLoadingProvider.request(.cateList, model: CTCateListModel.self) { (returnData) in
            self.collectionView.uempty?.allowShow = true
            
            self.topList = returnData?.topList ?? []
            self.rankList = returnData?.rankingList ?? []
            
            self.collectionView.reloadData()
            self.collectionView.uHead.endRefreshing()
        }
    }
    
    override func setupLayout() {
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints { (make) in
            make.edges.equalTo(self.view.usnp.edges)
        }
    }
    
    override func configNavBar() {
        super.configNavBar()
    }
}

extension BookViewController: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource{
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 0 {
            return topList.prefix(3).count
        } else {
            return rankList.count
        }
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.section == 0 {
            let cell = collectionView.dequeueReusableCell(for: indexPath, cellType: CTTopCollectionViewCell.self)
            cell.model = topList[indexPath.row]
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(for: indexPath, cellType: CTRankCollectionViewCell.self)
            cell.model = rankList[indexPath.row]
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 10, left: 10, bottom: section == 0 ? 0 : 10, right: 10)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = floor(Double(screenWidth - 40.0) / 3.0)
        return CGSize(width: width, height: (indexPath.section == 0 ? 55 : (width * 0.75 + 30)))
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        // mark -- 增加
        if indexPath.section == 0 {
                   let model = topList[indexPath.row]
                   var titles: [String] = []
                   var vcs: [UIViewController] = []
                   for tab in model.extra?.tabList ?? [] {
                       guard let tabTitle = tab.tabTitle else { continue }
                       titles.append(tabTitle)
                       vcs.append(CTComicListViewController(argCon: tab.argCon,
                                                           argName: tab.argName,
                                                           argValue: tab.argValue))
                   }
                   let vc = CTPageViewController(titles: titles, vcs: vcs, pageStyle: .topTabBar)
                   vc.title = model.sortName
                   navigationController?.pushViewController(vc, animated: true)
               }
               
               if indexPath.section == 1 {
                   let model = rankList[indexPath.row]
                   let vc = CTComicListViewController(argCon: model.argCon,
                                                     argName: model.argName,
                                                     argValue: model.argValue)
                   vc.title = model.sortName
                   navigationController?.pushViewController(vc, animated: true)
               }
    }
}

