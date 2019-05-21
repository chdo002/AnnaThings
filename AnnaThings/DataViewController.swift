//
//  DataViewController.swift
//  AnnaThings
//
//  Created by 陈栋 on 2019/4/23.
//  Copyright © 2019 chdo. All rights reserved.
//

import UIKit
import SnapKit
import SwiftDate

class DataViewController: UIViewController {
    
    let collectoinView = HorizontalCollectionView()
    
    let dataSource = IncidentData()
    
    var period :TimePeriod? {
        if let start = dataSource.incidentBoundary.0, let end = dataSource.incidentBoundary.1 {
            return TimePeriod(start: start.time.inDefaultRegion(),
                              end: end.time.inDefaultRegion())
        } else {
            return nil
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpView()
    }
    
    func setUpView(){
        view.backgroundColor = UIColor.white
        
        // segment
        let seg = UISegmentedControl(items: [IncidentData.DataTimeIntervalType.Day.rawValue,
                                             IncidentData.DataTimeIntervalType.Week.rawValue,
                                             IncidentData.DataTimeIntervalType.Month.rawValue])
        view.addSubview(seg)
        seg.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(75 + UIApplication.shared.statusBarFrame.height)
            make.leading.equalToSuperview().offset(10)
            make.trailing.equalToSuperview().offset(-10)
        }
        seg.selectedSegmentIndex = 1;
        seg.addTarget(self, action: #selector(tapSeg(_:)), for: .valueChanged)
        
        // chartView
        view.addSubview(collectoinView)
        collectoinView.snp.makeConstraints { (make) in
            make.leading.trailing.equalTo(seg)
            make.top.equalTo(seg.snp.bottom).offset(30)
            make.height.equalTo(300)
        }
        
        tapSeg(seg)
    }
    
    
    @objc func tapSeg(_ seg: UISegmentedControl) {
        if seg.selectedSegmentIndex != 1 {
            return
        }
        // 数据时间段
        collectoinView.intervalType = seg.intervalType
        collectoinView.incidentDataSource = dataSource.incidentInTimePeriod(peroid: period,
                                                                            type: seg.intervalType)
    }
}

extension UISegmentedControl {
    var intervalType : IncidentData.DataTimeIntervalType {
        var type = IncidentData.DataTimeIntervalType.Week
        if self.selectedSegmentIndex == 0 {
            type = .Day
        } else if self.selectedSegmentIndex == 1 {
            type = .Week
        } else if self.selectedSegmentIndex == 1 {
            type = .Month
        }
        return type
    }
}
