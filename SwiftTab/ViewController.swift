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
let minTabDensity:CGFloat = 0.7
/// 选中线高度
let selectLineHeight:CGFloat = 3
/// 选中线颜色 (默认和tab栏选中颜色相同)
let selectLineColor = tabItemHightColor
/// 选中宽度和当前tabitem文字宽度差值
let selectLineDifference:CGFloat = 5

class ViewController: UIViewController {
    /// tab 栏view
    let headerView = UIScrollView()
    /// tab 栏选中线view
    let selectLineView = UIView()
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
        headerView.showsHorizontalScrollIndicator = false
        self.view.addSubview(headerView)
        headerView.snp.makeConstraints{make in
            make.top.equalTo(self.view)
            make.left.equalTo(self.view)
            make.right.equalTo(self.view)
            make.height.equalTo(tabHeight)
        }
        //添加pageScroller
        pageView.backgroundColor = UIColor.yellow
        pageView.showsHorizontalScrollIndicator = false
        pageView.bounces = false
        self.view.addSubview(pageView)
        pageView.snp.makeConstraints{make in
            make.top.equalTo(headerView.snp.bottom)
            make.left.equalTo(self.view)
            make.right.equalTo(self.view)
            make.bottom.equalTo(self.view)
        }
        //添加下方横线
        selectLineView.backgroundColor = selectLineColor
        headerView.addSubview(selectLineView)
        //向page中添加tab项
        for (index,tabItem) in tabItems.enumerated() {
            self.pageView.addSubview(tabItem.pageController.view)
            tabItem.pageController.view.snp.makeConstraints{ make in
                make.top.equalTo(self.pageView)
                make.bottom.equalTo(self.pageView)
                make.height.equalTo(self.pageView)
                make.width.equalTo(self.view)
                if index == 0 {
                    make.left.equalTo(self.pageView)
                } else {
                    make.left.equalTo(tabItems[index - 1].pageController.view.snp.right)
                }
                if index == tabItems.count - 1 {
                    make.right.equalTo(self.pageView)
                }
                
            }
            self.addChildViewController(tabItem.pageController)
        }
        //调整page属性
        pageView.isPagingEnabled = true
        pageView.delegate = self
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        resizeTab()
        selectLineView.snp.makeConstraints{make in
            make.bottom.equalTo(headerView)
            make.height.equalTo(selectLineHeight)
            make.centerX.equalTo(tabItems.first!.tabBtn)
            make.width.equalTo(tabItems.first!.tabBtn).offset(selectLineDifference)
        }
    }
    /// 重新计算tab样式
    private func resizeTab() {
        //根据用户传入tab信息初始化header中tab项
        let padding = computeTabPadding()
        for (index,item) in tabItems.enumerated() {
            headerView.addSubview(item.tabBtn)
            //tab布局
            item.tabBtn.snp.makeConstraints{ make in
                make.bottom.equalTo(headerView)
                make.top.equalTo(headerView)
                make.height.equalTo(headerView)
                if index == 0 {
                    make.left.equalTo(headerView).offset(tabLRMargin)
                }else {
                    make.left.equalTo(tabItems[index - 1].tabBtn.snp.right).offset(padding)
                }
            }
            item.tabBtn.addTarget(self, action: #selector(tabClick), for: .touchUpInside)
        }
        tabItems.last?.tabBtn.snp.makeConstraints{ make in
            make.right.equalTo(headerView).offset(-tabLRMargin)
        }
    }
    /// tab按钮点击后样式变化
    ///
    /// - Parameter btn: 点击的按钮
    func tabClick(btn:UIButton){
        UIView.animate(withDuration: 0.3, animations: {
            self.selectLineView.snp.remakeConstraints{ make in
                make.bottom.equalTo(self.headerView)
                make.height.equalTo(selectLineHeight)
                make.centerX.equalTo(btn)
                make.width.equalTo(btn).offset(selectLineDifference)
            }
            // 使选中按钮在header滚动不超过边界的情况下居中
            self.center(btn)
            self.selectTab(btn)
            self.view.layoutIfNeeded()
        },completion: {
            guard $0 else {
                return
            }
            self.pageView.contentOffset.x = CGFloat(btn.tag) * self.view.frame.width
        })
    }
    /// 点击按钮 修改tab颜色
    ///
    /// - Parameter btn: 点击的tab
    func selectTab(_ btn:UIButton) {
        tabItems.forEach{$0.tabBtn.isSelected = false }
        btn.isSelected = true
    }
//    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
//        let padding = computeTabPadding(size.width)
//        for (index,item) in tabItems.enumerated() {
//            item.tabBtn.snp.updateConstraints{ make in
//                if index == 0 {
//                    make.left.equalTo(headerView).offset(tabLRMargin)
//                }else {
//                    make.left.equalTo(tabItems[index - 1].tabBtn.snp.right).offset(padding)
//                }
//            }
//        }
//    }
    /// 计算文字所占宽度
    ///
    /// - Parameter item: tab项
    /// - Returns: tab标题栏文字宽度
    private func getFontWidht(_ item:TabItem?) -> CGFloat{
        guard let item = item else {
            return 0
        }
        return NSString(string: item.title).size(attributes: [NSFontAttributeName:font]).width
    }
    /// 计算每个tab之间的间隔
    private func computeTabPadding(_ width:CGFloat? = nil) -> CGFloat{
        let width = width ?? self.headerView.frame.size.width
        //计算如果不发生滚动，平均放置到tab栏中，各项间距
        let tabTextTotalWidht = tabItems.reduce(CGFloat(0)){ $0 + getFontWidht($1)}
        let tabCount = CGFloat(tabItems.count)
        let padding = (width - 2 * tabLRMargin - tabTextTotalWidht) / (tabCount - 1)
        //根据tab密度决定是否需要滚动(按钮平均宽度和按钮之间空格比例)
        let tabDensity = padding / tabTextTotalWidht / tabCount
        if tabDensity < minTabDensity {
            return  minTabDensity * tabTextTotalWidht / tabCount
        }
        return padding
    }
    /// 添加测试数据
    private func testItem(){
        let c1 = PageItemViewController()
        c1.color = UIColor(colorLiteralRed: 254/255, green: 67/255, blue: 101/255, alpha: 1)
        c1.text = "1"
        let t1 = TabItem("个性推荐",pageController: c1)
        let c2 = PageItemViewController()
        c2.color = UIColor(colorLiteralRed: 252/255, green: 157/255, blue: 154/255, alpha: 1)
        c2.text = "2"
        let t2 = TabItem("歌单",pageController: c2)
        let c3 = PageItemViewController()
        c3.color = UIColor(colorLiteralRed: 249/255, green: 205/255, blue: 173/255, alpha: 1)
        c3.text = "3"
        let t3 = TabItem("主播电台",pageController: c3)
        let c4 = PageItemViewController()
        c4.color = UIColor(colorLiteralRed: 200/255, green: 200/255, blue: 169/255, alpha: 1)
        c4.text = "4"
        let t4 = TabItem("排行榜",pageController: c4)
        let c5 = PageItemViewController()
        c5.color = UIColor(colorLiteralRed: 131/255, green: 175/255, blue: 155/255, alpha: 1)
        c5.text = "5"
        let t5 = TabItem("这个标题特别长",pageController: c5)
        let c6 = PageItemViewController()
        c6.color = UIColor(colorLiteralRed: 254/255, green: 67/255, blue: 101/255, alpha: 1)
        c6.text = "6"
        let t6 = TabItem("短",pageController: c6)
        tabItems = [t1,t2,t3,t4,t5,t6]
    }
    
}
extension ViewController:UIScrollViewDelegate{
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let pagerContentOffsetX = scrollView.contentOffset.x
        //滑动比例
        let indexScale = pagerContentOffsetX/scrollView.contentSize.width * CGFloat(tabItems.count)
        //计算位移比例
        let diffentScale = indexScale - CGFloat(Int(indexScale))
        //计算下方横线的前一项和后一项的btn
        guard Int(indexScale) <  tabItems.count - 1 && indexScale > 0 else {
            return
        }
        let preBtn = tabItems[lroundf(Float(indexScale - 0.5))]
        let afterBtn = tabItems[lroundf(Float(indexScale + 0.5))]
        //然后计算2项tabitem中心点的差值
        let diffent = afterBtn.tabBtn.center.x - preBtn.tabBtn.center.x
        print("preBtn -> \(preBtn.title) afterBtn -> \(afterBtn.title)")
        print("diffent -> \(diffent)")
        //计算当松手后会滑向哪一个
        let nextIndex = lroundf(Float(indexScale))
        //高亮松手后tab
        selectTab(tabItems[nextIndex].tabBtn)
        //同时平滑过渡宽度
        selectLineView.snp.remakeConstraints{make in
            make.width.equalTo(preBtn.tabBtn.frame.width + selectLineDifference + (afterBtn.tabBtn.frame.width - preBtn.tabBtn.frame.width) * diffentScale)
            make.centerX.equalTo(preBtn.tabBtn.center.x + (diffentScale) * diffent)
            make.bottom.equalTo(self.headerView)
            make.height.equalTo(selectLineHeight)
        }
        // 使tab栏在滚动不超过边界的时候 横线屏幕居中
        center(self.selectLineView)
    }
    /// 使tab栏在滚动不超过边界的时候元素居中
    ///
    /// - Parameter view: 需要居中的元素
    func center(_ view:UIView) {
        //同时计算header选中条滚动到中间需要移动多少像素
        let postion = view.convert(CGPoint(x: -view.frame.width/2, y: 0 ), from: self.view).x
        self.headerView.contentOffset.x -= self.view.frame.size.width/2 + postion
        //判断是否超出滚动范围
        if self.headerView.contentOffset.x < 0 {
            self.headerView.contentOffset.x = 0
        }else if self.headerView.contentOffset.x > self.headerView.contentSize.width - self.headerView.frame.size.width {
            self.headerView.contentOffset.x = self.headerView.contentSize.width - self.headerView.frame.size.width
        }
    }
}
/// tab实体
struct TabItem {
    static var index = 0
    /// 每个tab对应的控制器
    let pageController:UIViewController
    /// tab栏标题
    let title:String
    /// 每个tab button样式
    let tabBtn:UIButton = UIButton()
    let id:Int = index
    init(_ title:String,pageController:UIViewController) {
        self.pageController = pageController
        self.title = title
        self.tabBtn.setTitle(title, for: .normal)
        self.tabBtn.setTitleColor(tabItemNormalColor, for: .normal)
        self.tabBtn.setTitleColor(tabItemHightColor, for: .highlighted)
        self.tabBtn.setTitleColor(tabItemHightColor, for: .selected)
        self.tabBtn.titleLabel?.font = font
        self.tabBtn.tag = TabItem.index
        TabItem.index += 1
    }
}
