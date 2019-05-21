//
//  ChartViewDelegate.swift
//  AnnaThings
//
//  Created by 陈栋 on 2019/5/21.
//  Copyright © 2019 chdo. All rights reserved.
//

import Foundation
import Charts

class ChartViewDel: ChartViewDelegate {
    
    func chartViewDidEndPanning(_ chartView: ChartViewBase) {
        
    }
    
    func chartTranslated(_ chartView: ChartViewBase, dX: CGFloat, dY: CGFloat) {
        
    }
    
    func chartValueNothingSelected(_ chartView: ChartViewBase) {
        
    }
    
    func chartScaled(_ chartView: ChartViewBase, scaleX: CGFloat, scaleY: CGFloat) {
        
    }
    
    func chartView(_ chartView: ChartViewBase, animatorDidStop animator: Animator) {
        
    }
    
    func chartValueSelected(_ chartView: ChartViewBase, entry: ChartDataEntry, highlight: Highlight) {
        if let incidents = entry.data as? [Incident] {
            for inci in incidents {
                print(inci.time.toFormat("MM月dd日，"))
            }
        }
    }
    
}
