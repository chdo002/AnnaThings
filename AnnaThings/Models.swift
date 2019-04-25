//
//  Models.swift
//  AnnaThings
//
//  Created by 陈栋 on 2019/4/23.
//  Copyright © 2019 chdo. All rights reserved.
//

import RealmSwift
import SwiftDate

func lastIncident(type: Incident.IncidentType) -> Incident? {
    let res = realm().objects(Incident.self).filter("type = %@", type.rawValue).sorted(byKeyPath: "time").last
    return res
}

func incidentsSeprateBy(intervelType: Incident.DataTimeIntervalType) -> [String: [Incident]]{
    
    let res = realm().objects(Incident.self)
    
    return Dictionary(grouping: res) { (ele) -> String in
    
        switch intervelType {
        case .Day:
            return ele.time.dateAt(DateRelatedType.startOfDay).toFormat("yyyy-MM-dd")
        case .Month:
            return ele.time.dateAt(DateRelatedType.startOfMonth).toFormat("yyyy-MM-dd")
        case .Week:
            return ele.time.dateAt(DateRelatedType.startOfWeek).toFormat("yyyy-MM-dd")
        }
    }
}

private func realm() -> Realm{
    let rl = try! Realm()
    return rl
}

class Incident: Object {
    
    enum IncidentType: Int8 {
        case pee
        case pupu
    }
    
    enum DataTimeIntervalType: String {
        case Month = "月"
        case Week = "周"
        case Day = "日"
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
