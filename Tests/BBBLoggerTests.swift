//
//  BBBLoggerTests.swift
//  BBBLoggerTests
//
//  Created by OTAKE Takayoshi on 2016/11/20.
//  Copyright © 2016 OTAKE Takayoshi. All rights reserved.
//

import XCTest
@testable import BBBLogger

class DocumentLogOutput: BBBLogOutput {
    let path: String
    init() {
        let dir = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
        path = NSString(string: dir).appendingPathComponent("test.log")
        print(path)
        
        let fm = FileManager()
        if fm.fileExists(atPath: path) {
            try? fm.removeItem(atPath: path)
        }
    }
    
    public func log(_ level: BBBLogLevel, _ date: Date, _ point: BBBLogPoint, _ message: String) {
        let string = BBBDefaultLogOutput.string(from: level, date, point, message) + "\n"
        if let outputStream = OutputStream(toFileAtPath: path, append: true) {
            outputStream.open()
            let data = string.data(using: .utf8)!
            XCTAssert(data.withUnsafeBytes {
                outputStream.write($0, maxLength: data.count)
                } >= 0)
            outputStream.close()
        }
        else {
            print("Warning: failed to write a log")
        }
    }
    
    public func log(_ level: BBBLogLevel, _ date: Date, _ message: String, _ function: String, _ file: String, _ line: Int) {

    }
}

class BBBLoggerTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func test001() {
        BBBLogger.setup(logOutput: BBBDefaultLogOutput.shared)
        
        BBBLog(.verbose, "Hello, world!")
    }
    
    func test002_document() {
        BBBLogger.setup(logOutput: DocumentLogOutput())
        
        BBBLog(.verbose, "Hello, world!")
        BBBLog(.debug, "Hello, world!")
        BBBLog(.info, "Hello, world!")
        BBBLog(.warning, "Hello, world!")
        BBBLog(.error, "Hello, world!")
        BBBLogSync()
        
        let dir = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
        let path = NSString(string: dir).appendingPathComponent("test.log")
        
        let log = try? String(contentsOfFile: path, encoding: .utf8)
        XCTAssertNotNil(log)
        print(log!, terminator: "")
    }
    
}
