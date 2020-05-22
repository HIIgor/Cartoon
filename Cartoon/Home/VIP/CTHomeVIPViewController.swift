//
//  CTHomeVIPViewController.swift
//  Cartoon
//
//  Created by xiangyaguo on 2020/5/14.
//  Copyright © 2020 HiIgor. All rights reserved.
//

import UIKit

class CTHomeVIPViewController: CTBaseViewController {

    private lazy var vipList = [CTComicListModel]()
    
    private lazy var collectionView: UICollectionView = {
        let layout = UCollectionViewSectionBackgroundLayout()
        layout.minimumInteritemSpacing = 5
        layout.minimumLineSpacing = 10
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = UIColor.background
        cv.delegate = self
        cv.dataSource = self
        cv.alwaysBounceVertical = true
        cv.register(cellType: CTComicCollectionViewCell.self)
        cv.register(supplementaryViewType: CTComicCollectionHeaderView.self, ofKind: UICollectionView.elementKindSectionHeader)
        cv.register(supplementaryViewType: CTComicCollectionFooterView.self, ofKind: UICollectionView.elementKindSectionFooter)
        cv.uHead = URefreshHeader{ [weak self] in self?.setupLoadData() }
        cv.uFoot = URefreshTipKissFooter(with: "VIP用户专享\nVIP用户可以免费阅读全部漫画哦~")
        cv.uempty = UEmptyView { [weak self] in self?.setupLoadData() }
        return cv
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupLoadData()
    }
    
    override func setupLayout() {
        view.addSubview(collectionView)
        collectionView.frame = view.bounds
    }
    
    private func setupLoadData() {
        ApiLoadingProvider.request(.vipList, model: CTVipListModel.self) { [weak self] returnData in
            self?.collectionView.uHead.endRefreshing()
            self?.collectionView.uempty?.allowShow = true
            
            self?.vipList = returnData?.newVipList ?? []
            self?.collectionView.reloadData()
        }
    }
}

extension CTHomeVIPViewController: UICollectionViewDataSource, UCollectionViewSectionBackgroundLayoutDelegateLayout {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return vipList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, backgroundColorForSectionAt section: Int) -> UIColor {
        return UIColor.white
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let comicList = vipList[section]
        return comicList.comics?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionView.elementKindSectionHeader {
            let head = collectionView.dequeueReusableSupplementaryView(ofKind: kind, for: indexPath, viewType: CTComicCollectionHeaderView.self)
            let comicList = vipList[indexPath.section]
            head.iconView.kf.setImage(urlString: comicList.titleIconUrl)
            head.titleLabel.text = comicList.itemTitle
            head.moreButton.isHidden = !comicList.canMore
            head.setMoreActionClosure {
                [weak self] in
                let vc = CTComicListViewController(argCon: comicList.argCon, argName: comicList.argName, argValue: comicList.argValue)
                vc.title = comicList.itemTitle
                self?.navigationController?.pushViewController(vc, animated: true)
            }
            return head
        } else {
            return collectionView.dequeueReusableSupplementaryView(ofKind: kind, for: indexPath, viewType: CTComicCollectionFooterView.self)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        let comicList = vipList[section]
        return comicList.itemTitle?.count ?? 0 > 0 ? CGSize(width: screenWidth, height: 44) : CGSize.zero
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        return vipList.count - 1 != section ? CGSize(width: screenWidth, height: 10) : CGSize.zero
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(for: indexPath, cellType: CTComicCollectionViewCell.self)
        cell.cellStyle = .withTitle
        let comicList = vipList[indexPath.section]
        cell.model = comicList.comics?[indexPath.row]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = floor(Double(screenWidth - 10.0) / 3.0)
        return CGSize(width: width, height: 240)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let comicList = vipList[indexPath.section]
        guard let model = comicList.comics?[indexPath.row] else { return }
        let vc = CTComicViewController(comicid: model.comicId)
        navigationController?.pushViewController(vc, animated: true)
    }
    
}

