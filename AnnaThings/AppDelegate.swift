//
//  AppDelegate.swift
//  AnnaThings
//
//  Created by 陈栋 on 2019/4/22.
//  Copyright © 2019 chdo. All rights reserved.
//

import UIKit

import SwiftDate

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        #if DEBUG
        
        if let path = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory,
                                                          FileManager.SearchPathDomainMask.allDomainsMask,
                                                          true).first {
            print(path)
        }
        #endif
        
        return true
    }
    
}

