//
//  CTHomeSubscribeViewController.swift
//  Cartoon
//
//  Created by xiangyaguo on 2020/5/21.
//  Copyright © 2020 HiIgor. All rights reserved.
//

import UIKit

class CTHomeSubscribeViewController: CTBaseViewController {

    private var subscribeList = [CTComicListModel]()
    
    private lazy var collectionView: UICollectionView = {
        let lt = UCollectionViewSectionBackgroundLayout()
        lt.minimumInteritemSpacing = 5
        lt.minimumLineSpacing = 10
        let cw = UICollectionView(frame: CGRect.zero, collectionViewLayout: lt)
        cw.backgroundColor = UIColor.background
        cw.delegate = self
        cw.dataSource = self
        cw.alwaysBounceVertical = true
        cw.register(cellType: CTComicCollectionViewCell.self)
        cw.register(supplementaryViewType: CTComicCollectionHeaderView.self, ofKind: UICollectionView.elementKindSectionHeader)
        cw.register(supplementaryViewType: CTComicCollectionFooterView.self, ofKind: UICollectionView.elementKindSectionFooter)
        cw.uHead = URefreshHeader{ [weak self] in self?.setupLoadData() }
        cw.uFoot = URefreshTipKissFooter(with: "使用妖气币可以购买订阅漫画\nVIP会员购买还有优惠哦~")
        cw.uempty = UEmptyView { [weak self] in self?.setupLoadData() }
        return cw
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupLoadData()
    }
    
    private func setupLoadData() {
        ApiLoadingProvider.request(.subscribeList, model: CTSubscribeListModel.self) {
            [weak self] (returnData) in
            self?.collectionView.uHead.endRefreshing()
            self?.collectionView.uempty?.allowShow = true
            
            self?.subscribeList = returnData?.newSubscribeList ?? []
            self?.collectionView.reloadData()
        }
    }
    
    override func setupLayout() {
        view.addSubview(collectionView)
        collectionView.frame = view.bounds;
    }
}

extension CTHomeSubscribeViewController: UCollectionViewSectionBackgroundLayoutDelegateLayout, UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return subscribeList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, backgroundColorForSectionAt section: Int) -> UIColor {
        return UIColor.white
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let comicList = subscribeList[section]
        return comicList.comics?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionView.elementKindSectionHeader {
            let head = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, for: indexPath, viewType: CTComicCollectionHeaderView.self)
            let comicList = subscribeList[indexPath.section]
            head.iconView.kf.setImage(urlString: comicList.titleIconUrl)
            head.titleLabel.text = comicList.itemTitle
            head.moreButton.isHidden = !comicList.canMore
            head.setMoreActionClosure { [weak self] in
                let vc = CTComicListViewController(argCon: comicList.argCon, argName: comicList.argName, argValue: comicList.argValue)
                vc.title = comicList.itemTitle
                self?.navigationController?.pushViewController(vc, animated: true)
            }
            return head
        } else {
            let foot = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionFooter, for: indexPath, viewType: CTComicCollectionFooterView.self)
            return foot
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        let comicList = subscribeList[section]
        return comicList.itemTitle?.count ?? 0 > 0 ? CGSize(width: screenWidth, height: 44) : CGSize.zero
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        return subscribeList.count - 1 != section ? CGSize(width: screenWidth, height: 10) : CGSize.zero
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(for: indexPath, cellType: CTComicCollectionViewCell.self)
        cell.cellStyle = .withTitle
        let comicList = subscribeList[indexPath.section]
        cell.model = comicList.comics?[indexPath.row]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = floor(Double(screenWidth - 10.0) / 3.0)
        return CGSize(width: width, height: 240)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let comicList = subscribeList[indexPath.section]
        guard let model = comicList.comics?[indexPath.row] else { return }
        let vc = CTComicViewController(comicid: model.comicId)
        navigationController?.pushViewController(vc, animated: true)
    }
    
}
