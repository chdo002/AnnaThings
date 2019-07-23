//
//  TodayViewController.swift
//  AnnalThEx
//
//  Created by 陈栋 on 2019/7/23.
//  Copyright © 2019 chdo. All rights reserved.
//

import UIKit
import NotificationCenter
import SnapKit

class TodayViewController: UIViewController, NCWidgetProviding {
        
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        let v = UIView()
        v.backgroundColor = UIColor.blue
        view.addSubview(v)
        v.snp.makeConstraints { (make) in
            make.left.top.equalToSuperview().offset(20)
            make.size.equalTo(CGSize(width: 50, height: 50))
        }
        
//        let url = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: "group.CY-50C12BE8-8D8E-11E9-8FB2-00E04C6845B6.com.cydia.Extender")
        
        self.extensionContext?.widgetLargestAvailableDisplayMode = .compact;
        
    }
    
    func widgetActiveDisplayModeDidChange(_ activeDisplayMode: NCWidgetDisplayMode, withMaximumSize maxSize: CGSize) {
        self.preferredContentSize = CGSize(width: 10, height: 20000)
    }
    
    func widgetPerformUpdate(completionHandler: (@escaping (NCUpdateResult) -> Void)) {
        // Perform any setup necessary in order to update the view.
        
        // If an error is encountered, use NCUpdateResult.Failed
        // If there's no update required, use NCUpdateResult.NoData
        // If there's an update, use NCUpdateResult.NewData
        
        completionHandler(NCUpdateResult.newData)
    }
    
}
