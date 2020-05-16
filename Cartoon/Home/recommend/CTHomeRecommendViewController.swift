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
        collectionView.delegate = nil
        collectionView.dataSource = nil
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
}
