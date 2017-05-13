//
//  ViewController.swift
//  SwiftTab
//
//  Created by akrio on 2017/5/13.
//  Copyright © 2017年 akrio. All rights reserved.
//

import UIKit
import SnapKit
//tab栏高度
let tabHeight = 40
/// tab栏背景色
let tabColor = UIColor(colorLiteralRed: 248/255, green: 248/255, blue: 248/255, alpha: 1)
/// tab里2边边距
let tabLRMargin:CGFloat = 15
let font = UIFont.systemFont(ofSize: 17)
/// tab按钮颜色
let tabItemNormalColor = UIColor.black
/// tab高亮时颜色
let tabItemHightColor = UIColor(colorLiteralRed: 212/255, green: 57/255, blue: 49/255, alpha: 1)
/// tab栏中按钮最小密度
let minTabDensity:CGFloat = 0.1

class ViewController: UIViewController {
    /// tab 栏view
    let headerView = UIScrollView()
    /// page view
    let pageView = UIScrollView()
    /// 每个tab项
    var tabItems:[TabItem] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        testItem()
        // Do any additional setup after loading the view, typically from a nib.
        //调整下navigation颜色
        self.navigationController?.navigationBar.isTranslucent = false
        
        //添加headerScroller
        headerView.backgroundColor = tabColor
        self.view.addSubview(headerView)
        headerView.snp.makeConstraints{make in
            make.top.equalTo(self.view)
            make.left.equalTo(self.view)
            make.right.equalTo(self.view)
            make.height.equalTo(tabHeight)
        }
        //添加pageScroller
        pageView.backgroundColor = UIColor.black
        self.view.addSubview(pageView)
        pageView.snp.makeConstraints{make in
            make.top.equalTo(headerView.snp.bottom)
            make.left.equalTo(self.view)
            make.right.equalTo(self.view)
            make.bottom.equalTo(self.view)
        }
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        resizeTab()
    }
    /// 重新计算tab样式
    private func resizeTab() {
        //根据用户传入tab信息初始化header中tab项
        let padding = computeTabPadding()
        for (index,item) in tabItems.enumerated() {
            headerView.addSubview(item.tabBtn)
            item.tabBtn.snp.makeConstraints{ make in
                make.centerY.equalTo(headerView)
                if index == 0 {
                    make.left.equalTo(headerView).offset(tabLRMargin)
                }else {
                    make.left.equalTo(tabItems[index - 1].tabBtn.snp.right).offset(padding)
                }
            }
        }

    }

    /// 计算每个tab之间的间隔
    private func computeTabPadding(_ width:CGFloat? = nil) -> CGFloat{
        let width = width ?? self.headerView.frame.size.width
        //计算如果不发生滚动，平均放置到tab栏中，各项间距
        let tabTextTotalWidht = tabItems.reduce(CGFloat(0)){ $0 + NSString(string: $1.tabBtn.currentTitle ?? "")
            .size(attributes: [NSFontAttributeName:font]).width}
        let tabCount = CGFloat(tabItems.count)
        let padding = (width - 2 * tabLRMargin - tabTextTotalWidht) / (tabCount - 1)
        //根据tab密度决定是否需要滚动(按钮平均宽度和按钮之间空格比例)
        let tabDensity = tabTextTotalWidht / tabCount / padding
        if tabDensity < minTabDensity {
            return 40
        }
        return padding
    }

    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        let padding = computeTabPadding(size.width)
        for (index,item) in tabItems.enumerated() {
            item.tabBtn.snp.updateConstraints{ make in
                make.centerY.equalTo(headerView)
                if index == 0 {
                    make.left.equalTo(headerView).offset(tabLRMargin)
                }else {
                    make.left.equalTo(tabItems[index - 1].tabBtn.snp.right).offset(padding)
                }
            }
        }
    }
    /// 添加测试数据
    private func testItem(){
        let t1 = TabItem(pageController: UIViewController(), tabBtn: UIButton())
        t1.tabBtn.setTitle("个性推荐", for: .normal)
        let t2 = TabItem(pageController: UIViewController(), tabBtn: UIButton())
        t2.tabBtn.setTitle("歌单", for: .normal)
        let t3 = TabItem(pageController: UIViewController(), tabBtn: UIButton())
        t3.tabBtn.setTitle("主播电台", for: .normal)
        let t4 = TabItem(pageController: UIViewController(), tabBtn: UIButton())
        t4.tabBtn.setTitle("排行榜", for: .normal)
        let t5 = TabItem(pageController: UIViewController(), tabBtn: UIButton())
        t5.tabBtn.setTitle("个性推荐", for: .normal)
        let t6 = TabItem(pageController: UIViewController(), tabBtn: UIButton())
        t6.tabBtn.setTitle("歌单", for: .normal)
//        let t7 = TabItem(pageController: UIViewController(), tabBtn: UIButton())
//        t7.tabBtn.setTitle("排行榜", for: .normal)
//        let t8 = TabItem(pageController: UIViewController(), tabBtn: UIButton())
//        t8.tabBtn.setTitle("主播电台", for: .normal)
        tabItems = [t1,t2,t3,t4,t5,t6]
    }

}
/// tab实体
struct TabItem {
    /// 每个tab对应的控制器
    let pageController:UIViewController
    /// 每个tab button样式
    let tabBtn:UIButton
    init(pageController:UIViewController,tabBtn:UIButton) {
        self.pageController = pageController
        self.tabBtn = tabBtn
        self.tabBtn.setTitleColor(tabItemNormalColor, for: .normal)
        self.tabBtn.setTitleColor(tabItemHightColor, for: .highlighted)
        self.tabBtn.titleLabel?.font = font
    }
}
