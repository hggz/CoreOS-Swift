//
//  COSystemInfo.swift
//  CoreOS
//
//  Created by hugogonzalez on 11/13/16.
//  Copyright © 2016 Cat Bakery. All rights reserved.
//

import UIKit

open class COSystemInfo: NSObject {
    open static var osName = UIDevice.current.systemName
    open static var osVersion = UIDevice.current.systemVersion
    open static var deviceModel = UIDevice.current.model
    
    open static func systemInformation() {
        print("Device Model: \(COSystemInfo.deviceModel)\nOS Name: \(COSystemInfo.osName)\nOS Version: \(COSystemInfo.osVersion)\n")
    }
}
