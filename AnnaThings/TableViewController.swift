//
//  TableViewController.swift
//  AnnaThings
//
//  Created by 陈栋 on 2019/4/23.
//  Copyright © 2019 chdo. All rights reserved.
//

import UIKit
import PKHUD
import RealmSwift

class TableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

    }

    fileprivate func savePee() {
      
        Alert(title: "💦本王要嘘嘘了", message: nil).addAction(UIAlertAction(title: "确定", style: .default, handler: { (_) in
            if let lastPee = latestIncident(type: .pee) {
                let inter = -lastPee.time.timeIntervalSinceNow
                if inter < 60 * 3 {
                    HUD.flash(HUDContentType.labeledError(title: "💦是不是才尿过？", subtitle: nil), delay: 1)
                    return
                }
            }
            
            HUD.flash(HUDContentType.success, delay: 0.5)
            let inci = Incident()
            inci.type = Incident.IncidentType.pee.rawValue
            inci.save()
        })).addAction(UIAlertAction(title: "取消", style: .cancel, handler: { (_) in
            
        })).showSelf(in: self)
    }
    
    fileprivate func savePoo() {
        
        Alert(title: "💩本王要噗噗了", message: nil).addAction(UIAlertAction(title: "确定", style: .default, handler: { (_) in
            if let lastPuu = latestIncident(type: .pupu) {
                let inter = -lastPuu.time.timeIntervalSinceNow
                if inter < 60 * 3 {
                    HUD.flash(HUDContentType.labeledError(title: "💩是不是才拉过？", subtitle: nil), delay: 1)
                    return
                }
            }
            HUD.flash(HUDContentType.success, delay: 0.5)
            let inci = Incident()
            inci.type = Incident.IncidentType.pupu.rawValue
            inci.save()
        })).addAction(UIAlertAction(title: "取消", style: .cancel, handler: { (_) in
            
        })).showSelf(in: self)
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if indexPath.row == 0 {
            savePee()
        } else if indexPath.row == 1 {
            savePoo()
        } else if indexPath.row == 2 {
            navigationController?.pushViewController(DataViewController(), animated: true)
        }
    }

}
