//
//  PersistanceTests.swift
//  WeatherAppTests
//
//  Created by Jovanco Jovanovski on 8/7/18.
//  Copyright © 2018 Jovanco Jovanovski. All rights reserved.
//

import XCTest

class PersistanceTests: XCTestCase {
    
    var sut: StorageManager!
    
    override func setUp() {
        super.setUp()
        sut = StorageManager()
    }
    
    override func tearDown() {
        sut = nil
        super.tearDown()
    }
    
    func testReadFromPlistFile()
    {
        //Test reading from plist file
    }
    
    func testWriteToPlistFile()
    {
        //Test writing to plist file
    }
}
