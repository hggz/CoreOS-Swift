//
//  COSystemInfo.swift
//  CoreOS
//
//  Created by hugogonzalez on 11/13/16.
//  Copyright © 2016 Cat Bakery. All rights reserved.
//

import UIKit

public struct COSystemInfo {
    public static var osName = UIDevice.current.systemName
    public static var osVersion = UIDevice.current.systemVersion
    public static var deviceModel = UIDevice.current.model
    
    public static func systemInformation() {
        print("Device Model: \(COSystemInfo.deviceModel)\nOS Name: \(COSystemInfo.osName)\nOS Version: \(COSystemInfo.osVersion)\n")
    }
}
