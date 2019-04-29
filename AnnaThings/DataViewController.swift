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
        let period = TimePeriod(end: DateInRegion(), duration: 1.months + 2.weeks)
        
        let sd = IncidentData().incidentInTimePeriod(peroid: period,
                                                     type: .Week)
        
        let vv = HorizontalCollectionView()
        view.addSubview(vv)
        vv.snp.makeConstraints { (make) in
            make.leading.trailing.equalTo(seg)
            make.top.equalTo(seg.snp.bottom).offset(30)
            make.height.equalTo(200)
        }
        
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


class HorizontalCollectionView: UICollectionView, UICollectionViewDataSource ,UICollectionViewDelegate {
    
    class Cell: UICollectionViewCell {
        
        var chartView: BarChartView!
        
        override init(frame: CGRect) {
            super.init(frame: frame)
            
            chartView = BarChartView(frame: CGRect.zero)
            addSubview(chartView)
            chartView.snp.makeConstraints { (make) in
                make.edges.equalToSuperview()
            }
        }
        
        func set(){
            if tag % 2 == 0 {
                backgroundColor = .blue
            } else {
                backgroundColor = .gray
            }
        }
        
        func setData(_ yVals: [BarChartDataEntry]) {
            
            var set1: BarChartDataSet! = nil
            if let set = chartView.data?.dataSets.first as? BarChartDataSet {
                set1 = set
                set1.replaceEntries(yVals)
                chartView.data?.notifyDataChanged()
                chartView.notifyDataSetChanged()
            } else {
                set1 = BarChartDataSet(entries: yVals, label: "The year 2017")
                set1.colors = ChartColorTemplates.material()
                set1.drawValuesEnabled = false
                
                let data = BarChartData(dataSet: set1)
                data.setValueFont(UIFont(name: "HelveticaNeue-Light", size: 10)!)
                data.barWidth = 0.9
                chartView.data = data
            }
        }
        
        required init?(coder aDecoder: NSCoder) {
            super.init(coder: aDecoder)
        }
    }
    
    init() {
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: UIScreen.main.bounds.width - 20, height: 200)
        layout.minimumLineSpacing = 0
        
        super.init(frame: CGRect.zero, collectionViewLayout: layout)
        
        register(Cell.self, forCellWithReuseIdentifier: "cell")
        showsHorizontalScrollIndicator = false
        backgroundColor = UIColor.white
        delegate = self
        dataSource = self
        isPagingEnabled = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! Cell
        cell.tag = indexPath.row
        cell.set()
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 13
    }
}
