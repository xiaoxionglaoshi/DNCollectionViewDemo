//
//  ViewController.swift
//  DNCollectionViewDemo
//
//  Created by mainone on 16/12/15.
//  Copyright © 2016年 wjn. All rights reserved.
//

import UIKit

let kScreenWidth = UIScreen.main.bounds.size.width
let kScreenHeight = UIScreen.main.bounds.size.height

fileprivate let cellID = "cellID"

class ViewController: UIViewController {
    
    var collectionView: UICollectionView!
    var flowLayout: UICollectionViewFlowLayout!
    
     fileprivate var longPressGesture: UILongPressGestureRecognizer!
    
    var dataArray: Array<Any> = {
        let info = Bundle.main.path(forResource: "CollectionInfo", ofType: "plist")
        let dic = NSDictionary(contentsOfFile: info!)
        let arr = dic?["info"]
        return arr as! [Any]
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        createCollectionView()
        print(dataArray)
        
        longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(self.handleLongGesture(_:)))
        self.collectionView.addGestureRecognizer(longPressGesture)
    }
    
    func handleLongGesture(_ gesture: UILongPressGestureRecognizer) {
        
        switch(gesture.state) {
            
        case UIGestureRecognizerState.began:
            guard let selectedIndexPath = self.collectionView.indexPathForItem(at: gesture.location(in: self.collectionView)) else {
                break
            }
            collectionView.beginInteractiveMovementForItem(at: selectedIndexPath)
        case UIGestureRecognizerState.changed:
            collectionView.updateInteractiveMovementTargetPosition(gesture.location(in: gesture.view!))
        case UIGestureRecognizerState.ended:
            collectionView.endInteractiveMovement()
        default:
            collectionView.cancelInteractiveMovement()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }

    // 初始化CollectionView
    func createCollectionView() {
        flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .vertical
        
        collectionView = UICollectionView(frame: self.view.bounds, collectionViewLayout: flowLayout)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = UIColor.clear
        collectionView.alwaysBounceVertical = true
        
        // 注册Cell
        collectionView.register(DNCollectionViewCell.self, forCellWithReuseIdentifier: cellID)
        self.view.addSubview(collectionView)
        
        // 页眉页脚设置
        collectionView.register(DNHeaderView.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "dnHeaderID")
        collectionView.register(DNFooterView.self, forSupplementaryViewOfKind: UICollectionElementKindSectionFooter, withReuseIdentifier: "dnFooterID")
        
    }
    
    
}

extension ViewController: UICollectionViewDataSource {
    
    // item个数
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return (dataArray[section] as! [Any]).count
    }
    
    // section个数
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return dataArray.count
    }
    
    // cell定制
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: DNCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: cellID, for: indexPath) as! DNCollectionViewCell
        cell.backgroundColor = UIColor.orange
        let arr = dataArray[indexPath.section] as! [Any]
        cell.textLabel?.text = "\(arr[indexPath.item])"
        return cell
    }
    
    // Header&Footer设置
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        switch kind {
        case UICollectionElementKindSectionHeader:
            let header: DNHeaderView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "dnHeaderID", for: indexPath) as! DNHeaderView
            header.backgroundColor = UIColor.red
            header.headerLabel?.text = "header: \(indexPath.section)"
            
            return header
        case UICollectionElementKindSectionFooter:
            let footer: DNFooterView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "dnFooterID", for: indexPath) as! DNFooterView
            footer.backgroundColor = UIColor.gray
            footer.footerLabel?.text = "footer: \(indexPath.section)"
            return footer
        default:
            return DNHeaderView()
        }
    }
    
    // 数据源方法，告知特定item是否可以移动
    func collectionView(_ collectionView: UICollectionView, canMoveItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    // 手势移动结束调动此方法，以最终确定目的地的IndexPath
//    func collectionView(_ collectionView: UICollectionView, targetIndexPathForMoveFromItemAt originalIndexPath: IndexPath, toProposedIndexPath proposedIndexPath: IndexPath) -> IndexPath {
//        return originalIndexPath
//    }
    
    // 在此处改变数据源中对应indexPath
    func collectionView(_ collectionView: UICollectionView, moveItemAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        var arr = dataArray[sourceIndexPath.section] as! [Any]
        let temp = arr.remove(at: sourceIndexPath.item)
        arr.insert(temp, at: destinationIndexPath.item)
    }
    
}

extension ViewController: UICollectionViewDelegate {
    // 点击事件
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("section: \(indexPath.section), item: \(indexPath.item)")
    }
    
    // 是否允许被选中
    func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    // 是否允许高亮
    func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    // 点击按下时执行
    func collectionView(_ collectionView: UICollectionView, didHighlightItemAt indexPath: IndexPath) {
//        let cell: UICollectionViewCell = collectionView.cellForItem(at: indexPath)!
//        cell.backgroundColor = UIColor.darkGray
    }
    
    // 点击选中后
    func collectionView(_ collectionView: UICollectionView, didUnhighlightItemAt indexPath: IndexPath) {
//        let cell: UICollectionViewCell = collectionView.cellForItem(at: indexPath)!
//        cell.backgroundColor = UIColor.red
    }
    
    // 允许多选是被调用
    func collectionView(_ collectionView: UICollectionView, shouldDeselectItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    // 当指定indexPath处的item被取消选择时触发，仅在允许多选时被调用
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
//        let cell: UICollectionViewCell = collectionView.cellForItem(at: indexPath)!
//        cell.backgroundColor = UIColor.orange
        print("被取消: \(indexPath.item)")
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        print("将要显示: \(indexPath.item)")
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplaySupplementaryView view: UICollectionReusableView, forElementKind elementKind: String, at indexPath: IndexPath) {
        print("将要显示辅助视图: \(indexPath.item)")
    }
    
    func collectionView(_ collectionView: UICollectionView, didEndDisplayingSupplementaryView view: UICollectionReusableView, forElementOfKind elementKind: String, at indexPath: IndexPath) {
        print("已经显示辅助视图: \(indexPath.item)")
    }
    
    // 长按出现的动作(如: cut, copy, paste)
    func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
        return false
    }
    
    func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
        if NSStringFromSelector(action) == "copy:" || NSStringFromSelector(action) == "cut:" {
            return true
        }
        return false
    }
    
    // 动作菜单被选择后执行
    func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
        if NSStringFromSelector(action) == "copy:" {
            print("copy: \(indexPath.item)")
        } else if NSStringFromSelector(action) == "cut:" {
            print("cut: \(indexPath.item)")
        }
        print("动作菜单被选择后执行: \(indexPath.item)")
    }
}

extension ViewController: UICollectionViewDelegateFlowLayout {
    // 每个item的大小
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let itemWidth = (kScreenWidth - 20 * 3 - 10)/4
        return CGSize(width: itemWidth, height: itemWidth)
    }
    
    // 每个collection的边距
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
    }
    
    // 设定全局的行间距，也可以直接设置UICollectionViewFlowLayout的minimumLineSpacing属性
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 20
    }
    
    //设定指定区内Cell的最小间距，也可以直接设置UICollectionViewFlowLayout的minimumInteritemSpacing属性
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 20
    }
    
    // 页眉的尺寸
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: 0, height: 50)
    }
    
    // 页脚的尺寸
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        return CGSize(width: 0, height: 50)
    }
    
}


