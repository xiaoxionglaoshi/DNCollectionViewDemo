//
//  DNHeaderView.swift
//  DNCollectionViewDemo
//
//  Created by mainone on 16/12/15.
//  Copyright © 2016年 wjn. All rights reserved.
//

import UIKit

class DNHeaderView: UICollectionReusableView {

    var headerLabel: UILabel?
    override init(frame: CGRect) {
        super.init(frame: frame)
        headerLabel = UILabel(frame: CGRect(x: 20, y: 0, width: 100, height: 50))
        self.addSubview(headerLabel!)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
