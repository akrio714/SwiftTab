//
//  PageViewController.swift
//  SwiftTab
//
//  Created by akrio on 2017/5/13.
//  Copyright © 2017年 akrio. All rights reserved.
//

import UIKit

class PageViewController: UIPageViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        //添加headerView
        let headerView = UIScrollView()
        headerView.backgroundColor = UIColor.blue
        self.view.addSubview(headerView)
        headerView.snp.makeConstraints{make in
            make.top.equalTo(self.view.frame.origin.x)
            make.left.equalTo(self.view)
            make.right.equalTo(self.view)
            make.height.equalTo(45)
        }
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    


}
