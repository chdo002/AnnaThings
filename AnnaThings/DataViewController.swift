//
//  DataViewController.swift
//  AnnaThings
//
//  Created by 陈栋 on 2019/4/23.
//  Copyright © 2019 chdo. All rights reserved.
//

import UIKit
import SnapKit
import Charts

class DataViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        setUpView()
    }
    
    enum DataTimeIntervalType: String {
        case Year = "年"
        case Month = "月"
        case Week = "周"
        case Day = "日"
    }
    
    func setUpView(){
        view.backgroundColor = UIColor.white
        
        let seg = UISegmentedControl(items: [DataTimeIntervalType.Year.rawValue,
                                             DataTimeIntervalType.Month.rawValue,
                                             DataTimeIntervalType.Week.rawValue,
                                             DataTimeIntervalType.Day.rawValue])
        view.addSubview(seg)
        seg.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(74)
            make.leading.equalToSuperview().offset(10)
            make.trailing.equalToSuperview().offset(-10)
        }
        seg.selectedSegmentIndex = 3;
        seg.addTarget(self, action: #selector(tapSeg(_:)), for: .valueChanged)
    }
    
    @objc func tapSeg(_ seg: UISegmentedControl) {
        
    }
}
