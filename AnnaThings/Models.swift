//
//  Models.swift
//  AnnaThings
//
//  Created by 陈栋 on 2019/4/23.
//  Copyright © 2019 chdo. All rights reserved.
//

import RealmSwift
import SwiftDate

// MARK: - 首页
func latestIncident(type: Incident.IncidentType) -> Incident? {
    let res = realm().objects(Incident.self).filter("type = %@", type.rawValue).sorted(byKeyPath: "time").last
    return res
}

// MARK: - 数据页
struct IncidentData {
    
    enum DataTimeIntervalType: String {
        case Month = "月"
        case Week = "周"
        case Day = "日"
    }
    
    private var incidents : Results<Incident>!
    init() {
        incidents = realm().objects(Incident.self).sorted(byKeyPath: "time")
    }
    
    var incidentBoundary : (Incident?, Incident?) {
        get {
            return (incidents.first, incidents.last)
        }
    }
    
    static let DateFormat = "yyyy-MM-dd-HH-mm"
    
    func incidentInTimePeriod(peroid timePeroid: TimePeriod, type: DataTimeIntervalType) -> [String: [Incident]]{
        
        let res = incidents.filter("time >= %@ and time =< %@", timePeroid.start!.date, timePeroid.end!.date)
        
        let dic = Dictionary(grouping: res) { (ele) -> String in
            switch type {
            case .Day:
                return ele.time.dateAt(.startOfDay).toFormat(IncidentData.DateFormat)
            case .Month:
                return ele.time.dateAt(.startOfMonth).toFormat(IncidentData.DateFormat)
            case .Week:
                return ele.time.dateAt(.startOfWeek).toFormat(IncidentData.DateFormat)
            }
        }
        return dic
    }
}

// MARK: - 数据

private func realm() -> Realm{
    let rl = try! Realm()
    return rl
}

class Incident: Object {
    
    enum IncidentType: Int8 {
        case pee
        case pupu
    }
    
    @objc dynamic var time: Date = Date()
    @objc dynamic var type: Int8 = IncidentType.pee.rawValue
    
    func save(){
        do {
            let rl = try Realm()
            print(rl.configuration.fileURL ?? "")
            try rl.write {
                rl.add(self)
            }
        } catch {
            print(error)
        }
    }
}
