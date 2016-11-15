//
//  COFileManagerTests.swift
//  CoreOS
//
//  Created by Hugo Gonzalez on 11/14/16.
//  Copyright © 2016 Cat Bakery. All rights reserved.
//

import XCTest
@testable import CoreOS

class COFileManagerTests: XCTestCase {
    var testBundle: Bundle?
    var testFilePath: String?
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        testBundle = Bundle(for: type(of: self))
        testFilePath = testBundle?.path(forResource: "test", ofType: "txt")
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testFileExists() {
        XCTAssert(fileExists(filePath: testFilePath!))
    }
    
    func testCurrentDirectory() {
        let cd = currentDirectory()
        XCTAssert(fileExists(filePath: cd))
    }
    
    func testFileNameFromFilePathWithExtension() {
        let fileName = fileNameFromFilePath(filePath: testFilePath!)
        XCTAssert("test.txt" == fileName)
    }
    
    func testFileNameFromFilePathWithoutExtension() {
        let fileName = fileNameFromFilePathWithoutExtension(filePath: testFilePath!)
        XCTAssert("test" == fileName)
    }
    
    func testFileDirectoryFromFilePath() {
        let filePathNSString = testFilePath! as NSString
        let fileName = filePathNSString.lastPathComponent
        let fileDirectory = filePathNSString.replacingOccurrences(of: fileName, with: "")
        let directory = directoryFromFilePath(filePath: testFilePath!)
        XCTAssert(fileDirectory == directory)
    }
    
    func testFilePathForFile() {
        let fileName = fileNameFromFilePath(filePath: testFilePath!)
        let directory = directoryFromFilePath(filePath: testFilePath!)
        let filePath = filePathForFile(name: fileName, directory: directory)
        XCTAssert(testFilePath! == filePath)
    }
    
    func testContentsOfDirectory() {
        let cd = currentDirectory()
        let contentsOfDir = contentsOfDirectory(dir: cd)
        for file in contentsOfDir {
            let filePath = filePathForFile(name: file, directory: cd)
            XCTAssert(fileExists(filePath: filePath))
        }
    }
    
    func testCopyFile() {
        let cacheDir = applicationCacheDirectory()
        let fileName = fileNameFromFilePath(filePath: testFilePath!)
        let newFilePath = filePathForFile(name: fileName, directory: cacheDir)
        copyFile(filePath: testFilePath!, destinationPath: newFilePath)
        XCTAssert(fileExists(filePath: newFilePath))
    }
    
    func testDeleteFile() {
        let cacheDir = applicationCacheDirectory()
        let fileName = fileNameFromFilePath(filePath: testFilePath!)
        let newFilePath = filePathForFile(name: fileName, directory: cacheDir)
        copyFile(filePath: testFilePath!, destinationPath: newFilePath)
        XCTAssert(fileExists(filePath: newFilePath))
        deleteFile(filePath: newFilePath)
        XCTAssert(!fileExists(filePath: newFilePath))
    }
    
    func testMoveFile() { 
        let cacheDir = applicationCacheDirectory()
        let fileName = fileNameFromFilePath(filePath: testFilePath!)
        let newFilePath = filePathForFile(name: fileName, directory: cacheDir)
        copyFile(filePath: testFilePath!, destinationPath: newFilePath)
        XCTAssert(fileExists(filePath: newFilePath))
        let documentsDir = applicationDocumentsDirectory()
        let newDocumentsFilePath = filePathForFile(name: fileName, directory: documentsDir)
        
        if fileExists(filePath: newDocumentsFilePath) { // delete file if moved to documents directory
            deleteFile(filePath: newDocumentsFilePath)
        }
        moveFile(filePath: newFilePath, destinationToMove: newDocumentsFilePath)
        XCTAssert(!fileExists(filePath: newFilePath))
        XCTAssert(fileExists(filePath: newDocumentsFilePath))
    }
    
    func testFilePathForResource() {
        let directory = directoryFromFilePath(filePath: testFilePath!)
        let resources = pathsForResources(ofType: "txt", filePath: directory)
        for file in resources {
            XCTAssert(fileExists(filePath: file))
        }
    }
}
