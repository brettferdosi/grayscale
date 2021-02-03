//
//  Logging.swift
//  grayscale
//
//  Created by Brett Gutstein on 1/31/21.
//  Copyright © 2021 Brett Gutstein. All rights reserved.
//

enum LogLevel: Int {
    case VERBOSE = 0
    case ALWAYS_PRINT
}

let currentLogLevel: LogLevel = .ALWAYS_PRINT

func grayscaleLog(logLevel: LogLevel = .ALWAYS_PRINT, _ format: String,
               file: String = #file, caller: String = #function, args: CVarArg...) {
    if (logLevel.rawValue >= currentLogLevel.rawValue) {
        let fileName = file.components(separatedBy: "/").last ?? ""
        NSLog("\(fileName):\(caller) " + format, args)
    }
}
