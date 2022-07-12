//
//  Model.swift
//  StopWatch
//
//  Created by Arstanbaeva Aisuluu on 07.07.2022.
//

import Foundation

struct TimerLogic {
    
    private var sec : Int = 0
    private var isTimer : Bool = true
    var isTime : Bool = false
    
    
    var updateTime : Int {
    mutating get {
            sec = isTimer ? sec + 1 : sec - 1
            if !isTimer && sec == 0{
                isTime = true
                return 0
            }
            return sec }
        set {
            sec = newValue
        }
    }
    
    
    mutating func setIsTimer (_ isTimer: Bool) {
        self.isTimer = isTimer
    }

    
    mutating func setSeconds(sec : Int) {
            self.sec = sec
        
    }
    
    func timeFormatted(_ seconds : Int = 0) -> String {
        var timeTuple = ""
        timeTuple.append(String(format: "%02d:", seconds / 3600))
        timeTuple.append(String(format: "%02d:", (seconds % 3600) / 60))
        timeTuple.append(String(format: "%02d", (seconds % 3600) % 60))
        return timeTuple
    }
   
}


