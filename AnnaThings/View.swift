//
//  View.swift
//  AnnaThings
//
//  Created by  chdo on 2019/5/19.
//  Copyright © 2019 chdo. All rights reserved.
//

import UIKit
import Charts
import SwiftDate

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
        layout.itemSize = CGSize(width: UIScreen.main.bounds.width - 20, height: 300)
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
        let name = _chartNames[indexPath.row]
        if let incidents =  _dataSource[name] {
            cell.setUpdata(incidents: incidents, for: name, of: intervalType)
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
            backgroundColor = .black
            chartView = BarChartView(frame: CGRect.zero)
            chartView.backgroundColor = .white
            chartView.rightAxis.enabled = false
            
            let yaixs = chartView.leftAxis
//            yaixs.drawLabelsEnabled = false
            yaixs.granularity = 1
            yaixs.axisMinimum = 0
            
            let xaixs = chartView.xAxis
            xaixs.labelPosition = .bottom
            xaixs.valueFormatter = XAIXFormatter()
            xaixs.drawGridLinesEnabled = false
            
            addSubview(chartView)
            chartView.snp.makeConstraints { (make) in
                make.edges.equalToSuperview()
            }
        }
        
        /// 设置表格数据
        ///
        /// - Parameters:
        ///   - incidents: 表格中的所有事件
        ///   - startDateString: 表格所在时间段起始时间
        ///   - intervalType: 时间段类型
        func setUpdata(incidents:[Incident], for startDateString:String, of intervalType: IncidentData.DataTimeIntervalType) {
            // 将事件拆分为子时间段
            let dic = incidents.incidentsSeprateBy(type: intervalType.decentType)
            
            var yVals = [BarChartDataEntry]()
            
            // 起始的日期
            guard let startDate = startDateString.toDate(IncidentData.DateFormat) else {
                return
            }
            
            // 结束的日期
            var endDate = startDate.dateAt(.endOfWeek)
            if intervalType == .Day {
                endDate = startDate.dateAt(.endOfDay)
            } else if intervalType == .Month {
                endDate = startDate.dateAt(.endOfMonth)
            }
            
            // 开始遍历需要遍历的日期
            var stepType = DateRelatedType.tomorrow
            var granularity = Calendar.Component.day
            if intervalType == .Day {
                stepType = .nearestHour(hour: 1)
                granularity = .hour
            }
            
            var dates = [DateInRegion]()
            var iterator = startDate
            while iterator.isBeforeDate(endDate, orEqual: true, granularity: granularity) {
                dates.append(iterator)
                iterator = iterator.dateAt(stepType)
            }
            
            for (index, showDate) in dates.enumerated() {
                
                var data : BarChartDataEntry = BarChartDataEntry()
                
                if let incidnets = dic[showDate.date.toFormat(IncidentData.DateFormat)] {
                    data = BarChartDataEntry(x: Double(index),
                                             yValues: [Double(incidents.peeIncidentCount), Double(incidents.pupuIncidentCount)],
                                             data: incidnets)
                } else {
                    data = BarChartDataEntry(x: Double(index), yValues: [0,0], data: nil)
                }
                yVals.append(data)
            }
            
            var set1: BarChartDataSet! = nil
            if let set = chartView.data?.dataSets.first as? BarChartDataSet {
                set1 = set
                set1.replaceEntries(yVals)
                chartView.data?.notifyDataChanged()
                chartView.notifyDataSetChanged()
            } else {
                set1 = BarChartDataSet(entries: yVals, label: startDateString)
                set1.colors = [ChartColorTemplates.material()[3],ChartColorTemplates.material()[1]]
                set1.drawValuesEnabled = true
                set1.valueFormatter = BarValueFormatter()
                
                let data = BarChartData(dataSet: set1)
                data.setValueFont(UIFont(name: "HelveticaNeue-Light", size: 10)!)
                data.barWidth = 0.8
                chartView.data = data
            }
        }
        
        required init?(coder aDecoder: NSCoder) {
            super.init(coder: aDecoder)
        }
    }
    
    class XAIXFormatter: IAxisValueFormatter {
        func stringForValue(_ value: Double, axis: AxisBase?) -> String {
            if value == 0 {
                return "星期日"
            } else if value == 1 {
                return "星期一"
            } else if value == 2 {
                return "星期二"
            } else if value == 3 {
                return "星期三"
            } else if value == 4 {
                return "星期四"
            } else if value == 5 {
                return "星期五"
            } else if value == 6 {
                return "星期六"
            }
            return ""
        }
    }
    
    class BarValueFormatter: IValueFormatter {
        func stringForValue(_ value: Double,
                            entry: ChartDataEntry,
                            dataSetIndex: Int,
                            viewPortHandler: ViewPortHandler?) -> String {
            
            if let incidents = entry.data as? [Incident], let first = incidents.first {
                if first.type == Incident.IncidentType.pee {
                    return "\(Int(value))次"
                }
                
                if first.type == Incident.IncidentType.pupu {
                    return "\(Int(value))次"
                }
            }
            return "\(Int(value))次"
        }
    }
    
}
