//
//  CTHomeRecommendViewController.swift
//  Cartoon
//
//  Created by 向亚国 on 2020/5/14.
//  Copyright © 2020 HiIgor. All rights reserved.
//

import UIKit
import LLCycleScrollView
import Reusable

class CTHomeRecommendViewController: CTBaseViewController {

    private var sex: Int = UserDefaults.standard.integer(forKey: String.sexTypeKey)
    
    private var galleryItems = [CTGalleryItemModel]()
    private var textItems = [CTTextItemModel]()
    private var comicLists = [CTComicListModel]()
    
    private lazy var bannerView: LLCycleScrollView = {
        let scrollView = LLCycleScrollView()
        scrollView.backgroundColor = UIColor.background
        scrollView.autoScrollTimeInterval = 6
        scrollView.placeHolderImage = UIImage(named: "normal_placeholder")
        scrollView.coverImage = UIImage()
        scrollView.pageControlPosition = .center
        scrollView.pageControlBottom = 20
        scrollView.titleBackgroundColor = .clear
        
        scrollView.lldidSelectItemAtIndex = didSelectBanners(index:)
        return scrollView
    }()
    
    private lazy var sexButton: UIButton = {
        let sn = UIButton(type: .custom)
        sn.setTitleColor(.black, for: .normal)
        return sn
    }()
    
    private lazy var collectionView: UICollectionView = {
        let layout = UCollectionViewSectionBackgroundLayout()
        layout.minimumInteritemSpacing = 5
        layout.minimumLineSpacing = 10
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = UIColor.background
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.alwaysBounceVertical = true
        collectionView.contentInset = UIEdgeInsets(top: screenWidth * 0.467, left: 0, bottom: 0, right: 0)
        collectionView.scrollIndicatorInsets = collectionView.contentInset
        
        // register
        collectionView.register(cellType: CTComicCollectionViewCell.self)
        collectionView.register(cellType: CTBoardCollectionViewCell.self)
        
        collectionView.register(supplementaryViewType: CTComicCollectionHeaderView.self, ofKind: UICollectionView.elementKindSectionHeader)
        collectionView.register(supplementaryViewType: CTComicCollectionFooterView.self, ofKind: UICollectionView.elementKindSectionFooter)
        // refresh
        collectionView.uHead = URefreshHeader { [weak self] in self?.setupLoadData(false) }
        collectionView.uFoot = URefreshDiscoverFooter()
        collectionView.uempty = UEmptyView(verticalOffset: -collectionView.contentInset.top) { self.setupLoadData(false) }
        
        return collectionView
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        setupLoadData(false)
    }
    
    @objc private func changeSex() {
        setupLoadData(true)
    }
    
    private func didSelectBanners(index: Int) {
        let item = galleryItems[index]
        if item.linkType == 2 {
            guard let url = item.ext?.compactMap({
                return $0.key == "url" ? $0.val : nil
            }).joined() else {
                return
            }
            let webVC = CTWebViewController(url: url)
            navigationController?.pushViewController(webVC, animated: true)
        } else {
            guard let comicIdString = item.ext?.compactMap({
                $0.key == "comicId" ? $0.val : nil
            }).joined(),
                let comicId = Int(comicIdString) else { return }
            
        }
    }
    
    private func setupLoadData(_ changeSex: Bool) {
        if changeSex {
            sex = 3 - sex
            UserDefaults.standard.set(sex, forKey: String.sexTypeKey)
            UserDefaults.standard.synchronize()
            NotificationCenter.default.post(name: .USexTypeDidChange, object: nil)
        }
        
        ApiLoadingProvider.request(CTApi.boutiqueList(sexType: sex), model: CTBoutiqueListModel.self) {
            [weak self] (returnData) in
            self?.galleryItems = returnData?.galleryItems ?? []
            self?.textItems = returnData?.textItems ?? []
            self?.comicLists = returnData?.comicLists ?? []
            
            self?.sexButton.setImage(UIImage(named: self?.sex == 1 ? "gender_male" : "gender_female"), for: .normal)
            self?.collectionView.uHead.endRefreshing()
            self?.collectionView.uempty?.allowShow = true
            
            self?.collectionView.reloadData()
            self?.bannerView.imagePaths = self?.galleryItems.filter {
                $0.cover != nil
            }.map { $0.cover! } ?? []
        }
    }
    
    override func setupLayout() {
        view.addSubview(collectionView)
        collectionView.frame = view.bounds
        
        view.addSubview(bannerView)
        bannerView.frame = CGRect(x: 0, y: 0, width: view.bounds.width, height: collectionView.contentInset.top)
        
        view.addSubview(sexButton)
        sexButton.frame = CGRect(x: view.bounds.width - 60, y: view.bounds.height - 20 - 80, width: 60, height: 60)
    }
}


extension CTHomeRecommendViewController: UCollectionViewSectionBackgroundLayoutDelegateLayout, UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return comicLists.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, backgroundColorForSectionAt section: Int) -> UIColor {
        return .white
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let comicList = comicLists[section]
        return comicList.comics?.prefix(4).count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionView.elementKindSectionHeader {
            let head = collectionView.dequeueReusableSupplementaryView(ofKind: kind, for: indexPath, viewType: CTComicCollectionHeaderView.self)
            let comicList = comicLists[indexPath.section]
            head.iconView.kf.setImage(urlString: comicList.newTitleIconUrl)
            head.titleLabel.text = comicList.itemTitle
            head.setMoreActionClosure { [weak self] in
                switch(comicList.comicType) {
                case .update:
                    let vc = CTUpdateListViewController(argCon: comicList.argCon, argName: comicList.argName, argValue: comicList.argValue)
                    vc.title = comicList.itemTitle
                    self?.navigationController?.pushViewController(vc, animated: true)
                case .thematic:
                    let vc = CTPageViewController(titles: ["漫画", "次元"], vcs: [
                        CTSpecialViewController(argCon: 2),
                    CTSpecialViewController(argCon: 4)], pageStyle: .navigationBarSegment)
                    self?.navigationController?.pushViewController(vc, animated: true)
                case .animation:
                    let vc = CTWebViewController(url: "http://m.u17.com/wap/cartoon/list")
                    vc.title = "动画"
                    self?.navigationController?.pushViewController(vc, animated: true)
                default:
                    let vc = CTComicListViewController(argCon: comicList.argCon, argName: comicList.argName, argValue: comicList.argValue)
                    vc.title = comicList.itemTitle
                    self?.navigationController?.pushViewController(vc, animated: true)
                }
            }
            return head
        } else {
            return collectionView.dequeueReusableSupplementaryView(ofKind: kind, for: indexPath, viewType: CTComicCollectionFooterView.self)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        let comicList = comicLists[section]
        return comicList.itemTitle?.count ?? 0 > 0 ? CGSize(width: screenWidth, height: 44) : CGSize.zero
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        return comicLists.count - 1 != section ? CGSize(width: screenWidth, height: 10) : CGSize.zero
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let comicList = comicLists[indexPath.section]
        if comicList.comicType == .billboard {
            let cell = collectionView.dequeueReusableCell(for: indexPath, cellType: CTComicCollectionViewCell.self)
            cell.model = comicList.comics?[indexPath.row]
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(for: indexPath, cellType: CTComicCollectionViewCell.self)
            if comicList.comicType == .thematic {
                cell.cellStyle = .none
            } else {
                cell.cellStyle = .withTitleAndDesc
            }
            cell.model = comicList.comics?[indexPath.row]
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

        let comicList = comicLists[indexPath.section]
        if comicList.comicType == .billboard {
            let width = floor((screenWidth - 15.0) / 4.0)
            return CGSize(width: width, height: 80)
        }else {
            if comicList.comicType == .thematic {
                let width = floor((screenWidth - 5.0) / 2.0)
                return CGSize(width: width, height: 120)
            } else {
                let count = comicList.comics?.takeMax(4).count ?? 0
                let warp = count % 2 + 2
                let width = floor((screenWidth - CGFloat(warp - 1) * 5.0) / CGFloat(warp))
                return CGSize(width: width, height: CGFloat(warp * 80))
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let comicList = comicLists[indexPath.section]
        guard let item = comicList.comics?[indexPath.row] else { return }
        
        if comicList.comicType == .billboard {
//            let vc
        } else {
            if item.linkType == 2 {
                guard let url = item.ext?.compactMap({
                    return $0.key == "url" ? $0.val : nil
                }).joined() else { return }
                let vc = CTWebViewController(url: url)
                navigationController?.pushViewController(vc, animated: true)
            } else {
                //TODO: CTComicController
                let vc = UIViewController()
                navigationController?.pushViewController(vc, animated: true)
            }
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView == collectionView {
            bannerView.frame = CGRect(x: 0, y: min(0, -(scrollView.contentOffset.y + scrollView.contentInset.top)), width: bannerView.bounds.width, height: bannerView.bounds.height)
//            bannerView.snp.updateConstraints{ $0.top.equalToSuperview().offset(min(0, -(scrollView.contentOffset.y + scrollView.contentInset.top))) }
        }
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        if scrollView == collectionView {
            UIView.animate(withDuration: 0.5, animations: {
                self.sexButton.transform = CGAffineTransform(translationX: 50, y: 0)
            })
        }
    }

    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if scrollView == collectionView {
            UIView.animate(withDuration: 0.5, animations: {
                self.sexButton.transform = CGAffineTransform.identity
            })
        }
    }

}
