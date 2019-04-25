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

func incidentsSeprateBy(intervelType: Incident.DataTimeIntervalType) -> [Date: [Incident]]{
    let res = realm().objects(Incident.self)
    return Dictionary(grouping: res) { (ele) -> Date in
        
        var format: String?
        switch intervelType {
        case .Year:
            format = "yyyy"
        case .Month:
            format = "yyyy-MM"
        case .Day:
            format = "yyyy-MM-dd"
        case .Week:
            format = nil
        }
        if let form = format {
            return ele.time.toFormat(form).toDate()!.date
        } else {
            return ele.time.dateAt(.startOfWeek)
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
        case Year = "年"
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
