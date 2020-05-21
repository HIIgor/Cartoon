//
//  CTComicTVTableViewCell.swift
//  Cartoon
//
//  Created by 向亚国 on 2020/5/18.
//  Copyright © 2020 HiIgor. All rights reserved.
//

import UIKit

class CTComicTVTableViewCell: CTBaseTableViewCell {
    var spinnerName: String?
    
    private lazy var iconView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        return iv
    }()
    
    private lazy var titleLabel: UILabel = {
        let tl = UILabel()
        tl.textColor = UIColor.black
        return tl
    }()
    
    private lazy var subtitleLabel: UILabel = {
        let sl = UILabel()
        sl.textColor = .gray
        sl.font = UIFont.systemFont(ofSize: 14)
        return sl
    }()
    
    private lazy var descLabel: UILabel = {
        let dl = UILabel()
        dl.textColor = .gray
        dl.numberOfLines = 3
        dl.font = UIFont.systemFont(ofSize: 14)
        return dl
    }()
    
    private lazy var tagLabel: UILabel = {
        let tl = UILabel()
        tl.textColor = .orange
        tl.font = UIFont.systemFont(ofSize: 14)
        return tl
    }()
    
    private lazy var orderView: UIImageView = {
        let ov = UIImageView()
        ov.contentMode = .scaleAspectFit
        return ov
    }()
    
    override func setupLayout() {
        separatorInset = .zero
        
        contentView.addSubview(iconView)
        iconView.snp.makeConstraints { make in
            make.left.top.bottom.equalToSuperview().inset(UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 0))
            make.width.equalTo(100)
        }
        
        contentView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.left.equalTo(iconView.snp.right).offset(10)
            make.right.equalToSuperview().offset(-10)
            make.height.equalTo(30)
            make.top.equalTo(iconView)
        }
        
        contentView.addSubview(subtitleLabel)
        subtitleLabel.snp.makeConstraints { make in
            make.left.equalTo(iconView.snp.right).offset(10)
            make.right.equalToSuperview().offset(-10)
            make.height.equalTo(20)
            make.top.equalTo(titleLabel.snp.bottom).offset(5)
        }
        
        contentView.addSubview(descLabel)
        descLabel.snp.makeConstraints { make in
            make.left.equalTo(iconView.snp.right).offset(10)
            make.right.equalToSuperview().offset(-10)
            make.height.equalTo(60)
            make.top.equalTo(subtitleLabel.snp.bottom).offset(5)
        }
        
        contentView.addSubview(orderView)
        orderView.snp.makeConstraints { make in
            make.bottom.equalTo(iconView.snp.bottom)
            make.height.width.equalTo(30)
            make.right.equalToSuperview().offset(-10)
        }
        
        contentView.addSubview(tagLabel)
        tagLabel.snp.makeConstraints { make in
            make.left.equalTo(iconView.snp.right).offset(10)
            make.right.equalTo(orderView.snp.left).offset(-10)
            make.height.equalTo(20)
            make.bottom.equalTo(iconView.snp.bottom)
        }
    }
    
    var model: CTComicModel? {
        didSet {
            guard let model = model else { return }
            iconView.kf.setImage(urlString: model.cover, placeholder: UIImage(named: "normal_placeholder_v"))
            titleLabel.text = model.name
            subtitleLabel.text = "\(model.tags?.joined(separator: " ") ?? "") | \(model.author_name ?? "")"
            descLabel.text = model.description
            if spinnerName == "更新时间" {
                let comicDate = Date().timeIntervalSince(Date(timeIntervalSince1970: TimeInterval(model.conTag)))
                var tagString = ""
                if comicDate < 60 {
                    tagString = "\(Int(comicDate))秒前"
                } else if comicDate < 3600 {
                    tagString = "\(Int(comicDate / 60))分前"
                } else if comicDate < 86400 {
                    tagString = "\(Int(comicDate / 3600))小时前"
                } else if comicDate < 31536000{
                    tagString = "\(Int(comicDate / 86400))天前"
                } else {
                    tagString = "\(Int(comicDate / 31536000))年前"
                }
                tagLabel.text = "\(spinnerName!) \(tagString)"
                orderView.isHidden = true
            } else {
                var tagString = ""
                if model.conTag > 100000000 {
                    tagString = String(format: "%.1f亿", Double(model.conTag) / 100000000)
                } else if model.conTag > 10000 {
                    tagString = String(format: "%.1f万", Double(model.conTag) / 10000)
                } else {
                    tagString = "\(model.conTag)"
                }
                if tagString != "0" { tagLabel.text = "\(spinnerName ?? "总点击") \(tagString)" }
                orderView.isHidden = false
            }
        }
    }
    
    var indexPath: IndexPath? {
        didSet {
            guard let indexPath = indexPath else { return }
            if indexPath.row == 0 { orderView.image = UIImage(named: "rank_frist") }
            else if indexPath.row == 1 { orderView.image = UIImage(named: "rank_second") }
            else if indexPath.row == 2 { orderView.image = UIImage(named: "rank_third") }
            else { orderView.image = nil }
        }
    }
}
