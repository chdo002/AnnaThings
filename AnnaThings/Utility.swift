//
//  Utility.swift
//  AnnaThings
//
//  Created by 陈栋 on 2019/4/23.
//  Copyright © 2019 chdo. All rights reserved.
//

import UIKit

struct Alert {
    private var alertVc : UIAlertController;
    public init(title: String?, message: String?){
        alertVc = UIAlertController(title: title, message: message, preferredStyle: .alert)
    }
    
    func addAction(_ action: UIAlertAction?) -> Alert{
        if let ac = action {
            alertVc.addAction(ac)
        }
        return self
    }
    
    func showSelf(in Vc: UIViewController){
        Vc.present(alertVc, animated: true) {
            
        }
    }
}


