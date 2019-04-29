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
import SwiftDate

class DataViewController: UIViewController {
    
    var chartView: LineChartView!
    var barChartView: BarChartView!
    
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
            make.top.equalToSuperview().offset(74)
            make.leading.equalToSuperview().offset(10)
            make.trailing.equalToSuperview().offset(-10)
        }
        seg.selectedSegmentIndex = 1;
        seg.addTarget(self, action: #selector(tapSeg(_:)), for: .valueChanged)
        
        // chartView
        chartView = LineChartView(frame: CGRect.zero)
        view.addSubview(chartView)
        chartView.snp.makeConstraints { (make) in
            make.leading.trailing.equalTo(seg)
            make.top.equalTo(seg.snp.bottom).offset(10)
            make.height.equalTo(200)
        }

        let period = TimePeriod(end: DateInRegion(), duration: 1.months + 2.weeks)
        
        let sd = IncidentData().incidentInTimePeriod(peroid: period,
                                                     type: .Week)
        
        
//        let res = incidentsSeprateBy(intervelType: .Week)
        
//        let dic : [String: [Incident]] = res.1
//
//        let boundary:(Incident?, Incident?) = res.0
//
//        guard let start = boundary.0, let end = boundary.1 else {
//            return
//        }
//
//        // 开始日期
//        let ss = start.time.dateAt(.startOfWeek)
//
//        // 结束日期
//        let ee = end.time.dateAt(.endOfWeek)
//
//        var bol = false
//        var currentDate = ss
//        var dates = [Date]()
//        repeat {
//            dates.append(currentDate)
//            let next = currentDate.dateAt(.tomorrow)
//            currentDate = next
//            bol = next.isBeforeDate(ee, orEqual: true, granularity: .day)
//        } while bol
//
//        let yVals = (0..<dates.count).map { (i) -> BarChartDataEntry in
//
//            return BarChartDataEntry(x: Double(i), y: 1)
//        }
    }
    
    
    @objc func tapSeg(_ seg: UISegmentedControl) {
        
    }
}


class HorizontalCollectionView: UICollectionView {
    class cell: UICollectionViewCell {
        override init(frame: CGRect) {
            super.init(frame: frame)
        }
        
        required init?(coder aDecoder: NSCoder) {
            super.init(coder: aDecoder)
        }
    }
    
    init() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        super.init(frame: CGRect.zero, collectionViewLayout: layout)
        
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    
}
