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
    
    var chartView: LineChartView!
    var barChartView: BarChartView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setUpView()
    }
    
    func setUpView(){
        view.backgroundColor = UIColor.white
        
        
        let seg = UISegmentedControl(items: [Incident.DataTimeIntervalType.Day.rawValue,
                                             Incident.DataTimeIntervalType.Week.rawValue,
                                             Incident.DataTimeIntervalType.Month.rawValue])
        view.addSubview(seg)
        
        seg.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(74)
            make.leading.equalToSuperview().offset(10)
            make.trailing.equalToSuperview().offset(-10)
        }
        
        seg.selectedSegmentIndex = 1;
        
        seg.addTarget(self, action: #selector(tapSeg(_:)), for: .valueChanged)
        
        chartView = LineChartView(frame: CGRect.zero)
        view.addSubview(chartView)
        chartView.snp.makeConstraints { (make) in
            make.leading.trailing.equalTo(seg)
            make.top.equalTo(seg.snp.bottom).offset(10)
            make.height.equalTo(200)
        }
        
        let dic : [String: [Incident]] = incidentsSeprateBy(intervelType: .Week)
        
        let yVals = (0...6).map { (i) -> BarChartDataEntry in
            
            return BarChartDataEntry(x: Double(i), y: 1)
        }
    }
    
    
    @objc func tapSeg(_ seg: UISegmentedControl) {
        
    }
}
