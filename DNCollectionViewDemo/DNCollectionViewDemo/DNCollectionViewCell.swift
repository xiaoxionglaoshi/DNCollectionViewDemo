//
//  DNCollectionViewCell.swift
//  DNCollectionViewDemo
//
//  Created by mainone on 16/12/15.
//  Copyright © 2016年 wjn. All rights reserved.
//

import UIKit

class DNCollectionViewCell: UICollectionViewCell {
    var textLabel: UILabel?
    override init(frame: CGRect) {
        super.init(frame: frame)
        textLabel = UILabel(frame: self.bounds)
        textLabel?.textAlignment = .center
        textLabel?.numberOfLines = 2
        self.addSubview(textLabel!)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
