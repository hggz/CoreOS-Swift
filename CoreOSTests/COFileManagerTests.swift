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
        XCTAssert(COFileManager.fileExists(filePath: testFilePath!))
    }
    
    func testCurrentDirectory() {
        let cd = COFileManager.currentDirectory()
        XCTAssert(COFileManager.fileExists(filePath: cd))
    }
    
    func testFileNameFromFilePathWithExtension() {
        let fileName = COFileManager.fileNameFromFilePath(filePath: testFilePath!)
        XCTAssert("test.txt" == fileName)
    }
    
    func testFileNameFromFilePathWithoutExtension() {
        let fileName = COFileManager.fileNameFromFilePathWithoutExtension(filePath: testFilePath!)
        XCTAssert("test" == fileName)
    }
    
    func testFileDirectoryFromFilePath() {
        let filePathNSString = testFilePath! as NSString
        let fileName = filePathNSString.lastPathComponent
        let fileDirectory = filePathNSString.replacingOccurrences(of: fileName, with: "")
        let directory = COFileManager.directoryFromFilePath(filePath: testFilePath!)
        XCTAssert(fileDirectory == directory)
    }
    
    func testFilePathForFile() {
        let fileName = COFileManager.fileNameFromFilePath(filePath: testFilePath!)
        let directory = COFileManager.directoryFromFilePath(filePath: testFilePath!)
        let filePathForFile = COFileManager.filePathForFile(name: fileName, directory: directory)
        XCTAssert(testFilePath! == filePathForFile)
    }
    
    func testContentsOfDirectory() {
        let cd = COFileManager.currentDirectory()
        let contentsOfDir = COFileManager.contentsOfDirectory(dir: cd)
        for file in contentsOfDir {
            let filePathForFile = COFileManager.filePathForFile(name: file, directory: cd)
            XCTAssert(COFileManager.fileExists(filePath: filePathForFile))
        }
    }
    
    func testCopyFile() {
        let cacheDir = COFileManager.applicationCacheDirectory()
        let fileName = COFileManager.fileNameFromFilePath(filePath: testFilePath!)
        let newFilePath = COFileManager.filePathForFile(name: fileName, directory: cacheDir)
        COFileManager.copy(filePath: testFilePath!, destinationPath: newFilePath)
        XCTAssert(COFileManager.fileExists(filePath: newFilePath))
    }
    
    func testDeleteFile() {
        let cacheDir = COFileManager.applicationCacheDirectory()
        let fileName = COFileManager.fileNameFromFilePath(filePath: testFilePath!)
        let newFilePath = COFileManager.filePathForFile(name: fileName, directory: cacheDir)
        COFileManager.copy(filePath: testFilePath!, destinationPath: newFilePath)
        XCTAssert(COFileManager.fileExists(filePath: newFilePath))
        COFileManager.deleteFile(filePath: newFilePath)
        XCTAssert(!COFileManager.fileExists(filePath: newFilePath))
    }
    
    func testMoveFile() { 
        let cacheDir = COFileManager.applicationCacheDirectory()
        let fileName = COFileManager.fileNameFromFilePath(filePath: testFilePath!)
        let newFilePath = COFileManager.filePathForFile(name: fileName, directory: cacheDir)
        COFileManager.copy(filePath: testFilePath!, destinationPath: newFilePath)
        XCTAssert(COFileManager.fileExists(filePath: newFilePath))
        let documentsDir = COFileManager.applicationDocumentsDirectory()
        let newDocumentsFilePath = COFileManager.filePathForFile(name: fileName, directory: documentsDir)
        
        if COFileManager.fileExists(filePath: newDocumentsFilePath) { // delete file if moved to documents directory
            COFileManager.deleteFile(filePath: newDocumentsFilePath)
        }
        COFileManager.move(filePath: newFilePath, destinationToMove: newDocumentsFilePath)
        XCTAssert(!COFileManager.fileExists(filePath: newFilePath))
        XCTAssert(COFileManager.fileExists(filePath: newDocumentsFilePath))
    }
    
    func testFilePathForResource() {
        let directory = COFileManager.directoryFromFilePath(filePath: testFilePath!)
        let resources = COFileManager.pathsForResources(ofType: "txt", filePath: directory)
        for file in resources {
            XCTAssert(COFileManager.fileExists(filePath: file))
        }
    }
}
