//
//  BBBLogger.swift
//  BBBLogger
//
//  Created by OTAKE Takayoshi on 2016/11/20.
//  Copyright © 2016 OTAKE Takayoshi. All rights reserved.
//

import UIKit

public enum BBBLogLevel: CustomStringConvertible {
    case verbose
    case debug
    case info
    case warning
    case error
    
    public var description: String {
        get {
            switch self {
            case .verbose:
                return "V"
            case .debug:
                return "D"
            case .info:
                return "I"
            case .warning:
                return "W"
            case .error:
                return "E"
            }
        }
    }
}

public extension DateFormatter {
    convenience init(format: String) {
        self.init()
        self.dateFormat = format
    }
}

public struct BBBLogPoint: CustomStringConvertible {
    public let function: String
    public let file: String
    public let line: Int
    
    public var description: String {
        get {
            return "at \(function) in \(file):\(line)"
        }
    }
}

public protocol BBBLogOutput {
    /// Log the `message`, that occurred at `point` at `date`, with `level`
    ///
    /// - parameter level: the log level
    /// - parameter date: the date the log occurred
    /// - parameter point: the point the log occurred
    /// - parameter message: the log message
    func log(_ level: BBBLogLevel, _ date: Date, _ point: BBBLogPoint, _ message: String)
}

public struct BBBDefaultLogOutput: BBBLogOutput {
    public static let dateFormatter = DateFormatter(format: "yyyy-MM-dd HH:mm:ss.SSS")
    public static func string(from level: BBBLogLevel, _ date: Date, _ point: BBBLogPoint, _ message: String) -> String {
        return "\(dateFormatter.string(from: date)) \(level) \(message) \n    \(point)"
    }
    
    public static let shared = BBBDefaultLogOutput()
    
    /// BBBLogOutput protocol
    public func log(_ level: BBBLogLevel, _ date: Date, _ point: BBBLogPoint, _ message: String) {
        Swift.print(BBBDefaultLogOutput.string(from: level, date, point, message), terminator: "\n")
    }
    
    private init() {}
}

/// Provides simple logging API
///
/// You can change log output, see `setup(logOutput:)` and `BBBLogOutput` protocol for more information.
///
/// Default log output is `BBBDefaultLogOutput` writes into the standard output.
public struct BBBLogger {
    static let serialQueue = DispatchQueue(label: "BBBLogger")
    static var logOutput: BBBLogOutput = BBBDefaultLogOutput.shared
    
    /// See `BBBDefaultLogOutput` for more information.
    public static func setup(logOutput: BBBLogOutput) {
        BBBLogger.logOutput = logOutput
    }
    
    /// Logs asynchronously
    ///
    /// - parameters:
    ///   - level: the log level
    ///   - format: the log message format
    ///   - arguments: the log message arguments
    ///   - function: the function the log occurred
    ///   - file: the file that contains the function the log occurred
    ///   - line: the line in the file the log occurred
    ///
    /// - Note:
    /// Usually, it is not necessary to specify following parameters:
    ///   - function
    ///   - file
    ///   - line
    public static func log(_ level: BBBLogLevel, _ format: String, _ arguments: CVarArg..., function: String = #function, file: String = #file, line: Int = #line) {
        let date = Date()
        let message = String(format: format, arguments)
        serialQueue.async {
            logOutput.log(level, date, BBBLogPoint(function: function, file: file, line: line), message)
        }
    }
    
    /// Waits until complete logging before
    public static func sync() {
        serialQueue.sync {
        }
    }
    
    private init() {}
}


/// Logs asynchronously
///
/// - Note: This func is alias for `BBBLogger.log(_:_:_:function:file:line:)`
public func BBBLog(_ level: BBBLogLevel, _ format: String, _ arguments: CVarArg..., function: String = #function, file: String = #file, line: Int = #line) {
    BBBLogger.log(level, format, arguments, function: function, file: file, line: line)
}

/// Waits until complete logging before
///
/// - Note: This func is alias for `BBBLogger.sync()`
public func BBBLogSync() {
    BBBLogger.sync()
}

/// Logs synchronously
public func BBBLogSync(_ level: BBBLogLevel, _ format: String, _ arguments: CVarArg..., function: String = #function, file: String = #file, line: Int = #line) {
    BBBLogger.log(level, format, arguments, function: function, file: file, line: line)
    BBBLogger.sync()
}
