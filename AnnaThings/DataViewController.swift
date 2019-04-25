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
    
    func setUpView(){
        view.backgroundColor = UIColor.white
        
        let seg = UISegmentedControl(items: [Incident.DataTimeIntervalType.Day.rawValue,
                                             Incident.DataTimeIntervalType.Week.rawValue,
                                             Incident.DataTimeIntervalType.Month.rawValue
                                             ])
        view.addSubview(seg)
        
        seg.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(74)
            make.leading.equalToSuperview().offset(10)
            make.trailing.equalToSuperview().offset(-10)
        }
        
        seg.selectedSegmentIndex = 0;
        
        seg.addTarget(self, action: #selector(tapSeg(_:)), for: .valueChanged)
        
        let dic = incidentsSeprateBy(intervelType: .Day)
        
    }
    
    @objc func tapSeg(_ seg: UISegmentedControl) {
        
    }
}
