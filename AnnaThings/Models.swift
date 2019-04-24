//
//  Models.swift
//  AnnaThings
//
//  Created by 陈栋 on 2019/4/23.
//  Copyright © 2019 chdo. All rights reserved.
//

import RealmSwift

func lastIncident(type: Incident.IncidentType) -> Incident? {
    let res = realm().objects(Incident.self).filter("type = %@", type.rawValue).sorted(byKeyPath: "time").last
    return res
}

func incidentsBy(){
    
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
    
    @objc dynamic var time: Date?
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
