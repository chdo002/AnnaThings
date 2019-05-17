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
    
    let collectoinView = HorizontalCollectionView()
    
    let dataSource = IncidentData()
    
    var period :TimePeriod {
        return TimePeriod(start: dataSource.incidentBoundary.0!.time.inDefaultRegion(),
                          end: dataSource.incidentBoundary.1!.time.inDefaultRegion())
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
            make.height.equalTo(200)
        }
        
        tapSeg(seg)
    }
    
    
    @objc func tapSeg(_ seg: UISegmentedControl) {
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

// MARK: - 表格
class HorizontalCollectionView: UICollectionView, UICollectionViewDataSource ,UICollectionViewDelegate {
    
    private var _dataSource: [String: [Incident]] = [:]
    private var _chartNames:[String] = []
    
    var intervalType = IncidentData.DataTimeIntervalType.Week
    
    var incidentDataSource: [String: [Incident]] {
        set {
            _dataSource = newValue
            _chartNames = newValue.keys.sorted(by: { (a, b) -> Bool in
                return a < b
            })
            reloadData()
        }
        get {
            return _dataSource
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
        if let incidents =  _dataSource[_chartNames[indexPath.row]] {
            cell.setUpdata(incidents: incidents, intervalType: intervalType)
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return incidentDataSource.count
    }
    
    // MARK: 表格CEll
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
        
        func setUpdata(incidents:[Incident], intervalType: IncidentData.DataTimeIntervalType) {
            
            let dic = incidents.incidentsSeprateBy(type: intervalType.decentType)
            
            let _chartNames = dic.keys.sorted(by: { (a, b) -> Bool in
                return a < b
            })
            
            var yVals = [BarChartDataEntry]()
            
            for (index, name) in _chartNames.enumerated() {
                let data = BarChartDataEntry(x: Double(index), y: Double(dic[name]!.count), data: dic[name]!)
                yVals.append(data)
            }
            setData(yVals)
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
                data.barWidth = 0.2
                chartView.data = data
            }
        }
        
        required init?(coder aDecoder: NSCoder) {
            super.init(coder: aDecoder)
        }
    }
    
}
