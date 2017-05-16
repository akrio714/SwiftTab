//
//  PageItemViewController.swift
//  SwiftTab
//
//  Created by akrio on 2017/5/16.
//  Copyright © 2017年 akrio. All rights reserved.
//

import UIKit

class PageItemViewController: UIViewController {
    var color:UIColor = UIColor.clear
    var text:String = ""
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.view.backgroundColor = color
        let label = UILabel()
        label.text = text
        label.font = UIFont.boldSystemFont(ofSize: 35)
        self.view.addSubview(label)
        label.snp.makeConstraints{ make in
            make.centerX.centerY.equalTo(self.view)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
