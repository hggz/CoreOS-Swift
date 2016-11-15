//
//  COFileManager.swift
//  CoreOS
//
//  Created by hugogonzalez on 11/13/16.
//  Copyright © 2016 Cat Bakery. All rights reserved.
//

import UIKit

fileprivate enum FileManagerError: String {
    case delete     = "Error Deleting File"
    case copy       = "Error Copying File"
    case move       = "Error moving File"
}

// MARK: - Private Properties
fileprivate var fm = FileManager.default

// MARK: - Open Static Functions

/// Indication whether or not a file at the given filepath exists.
///
/// - parameter filePath: file to verify its existence.
///
/// - returns: boolean indicating whether the file exists (true) or doesn't (false)
public func fileExists(filePath: String) -> Bool {
    return fm.fileExists(atPath: filePath)
}

/// Current location of the program
///
/// - returns: string representation of location
public func currentDirectory() -> String {
    return fm.currentDirectoryPath
}

/// Location of the application's documents directory
///
/// - returns: string representation of location
public func applicationDocumentsDirectory() -> String {
    return NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
}

/// Location of the application's resources directory.
///
/// - returns: string representation of location
public func applicationResourcesDirectory() -> String {
    guard let resourcesPath = Bundle.main.resourcePath else {
        return ""
    }
    return resourcesPath
}

/// Location of the application's cache directory.
///
/// - returns: string representation of location
public func applicationCacheDirectory() -> String {
    return NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true).first!
}

/// Deletes a file given the destination of the file to delete. Returns if file doesn't exist. You can ONLY delete from the cache dir on a production app.
///
/// - parameter filePath: destination of file to delete.
public func deleteFile(filePath: String) {
    guard fileExists(filePath: filePath) else {
        return
    }
    do {
        try fm.removeItem(atPath: filePath)
    } catch (let err) {
        fileManagerError(errorKind: .delete, error: err)
    }
}

/// Copies a file from filePath to the destination path. You can ONLY copy to the cache dir on a production mobile app.
///
/// - parameter filePath:        file path of file you want to copy over to destinationPath
/// - parameter destinationPath: destination you want the file you're copying to reach. This path must contain the final destination name of the file you want to be copied.
public func copyFile(filePath: String, destinationPath: String) {
    guard fileExists(filePath: filePath) && !fileExists(filePath: destinationPath) else {
        return
    }
    do {
        try fm.copyItem(atPath: filePath, toPath: destinationPath)
    } catch (let err) {
        fileManagerError(errorKind: .copy, error: err)
    }
}

/// Overwrites a file from filePath to the destination path by deleting the file at the destination first and then copying over the target. You can ONLY overwrite from the cache dir on a production mobile app.
///
/// - parameter filePath:        file path of file you want to copy over to destinationPath
/// - parameter destinationToOverride: destination you want the file you're copying to reach. This path must contain the final destination name of the file you want to be copied.
public func overwriteFile(filePath: String, destinationToOverride: String) {
    guard fileExists(filePath: filePath) && fileExists(filePath: destinationToOverride) else {
        return
    }
    deleteFile(filePath: destinationToOverride)
    copyFile(filePath: filePath, destinationPath: destinationToOverride)
}

/// Overwrites a file from filePath to the destination path. You can move ONLY in the context of the cache dir on a production mobile app.
///
/// - parameter filePath:        file path of file you want to copy over to destinationPath
/// - parameter destinationToMove: destination you want the file you're copying to reach. This path must contain the final destination name of the file you want to be copied.
public func moveFile(filePath: String, destinationToMove: String) {
    guard fileExists(filePath: filePath) else {
        return
    }
    do {
        try fm.moveItem(atPath: filePath, toPath: destinationToMove)
    } catch (let err) {
        fileManagerError(errorKind: .move, error: err)
    }
}

/// Provides an array of file paths for each item in a directory.
///
/// - parameter dir: Filepath of directory you wan't to have returned.
///
/// - returns: an array of file paths for each item in dir
public func contentsOfDirectory(dir: String) -> [String] {
    let dirEnumerator = fm.enumerator(atPath: dir)
    var fileList: [String] = []
    while let file = dirEnumerator?.nextObject() as? String {
        fileList.append(file)
    }
    return fileList
}

/// Provides an array of file paths of a specific file type in the application
///
/// - parameter ofType:   file types to be searching for.
/// - parameter filePath: directory to search in.
///
/// - returns: an array of files of the matching file type in the application
public func applicationPathsForResources(ofType: String) -> [String] {
    let bundle = Bundle.main
    return pathsForResources(ofType: ofType, bundle: bundle)
}

/// Provides an array of file paths of a specific file type at a specified location
///
/// - parameter ofType:   file types to be searching for.
/// - parameter filePath: directory to search in.
///
/// - returns: an array of files of the matching file type at the specified directory.
public func pathsForResources(ofType: String, filePath: String) -> [String] {
    guard let bundle = Bundle(path: filePath) else {
        return []
    }
    return pathsForResources(ofType: ofType, bundle: bundle)
}

/// Provides a file path for a file at a given directory.
///
/// - parameter name:      file name to be appended to a directory.
/// - parameter directory: directory to store the file name in.
///
/// - returns: a string file path of the file provided at the given directory.
public func filePathForFile(name: String, directory: String) -> String {
    guard fileExists(filePath: directory) else {
        return ""
    }
    let dir = directory as NSString
    return dir.appendingPathComponent(name)
}

/// Provides the filename of a filepath with extension.
///
/// - parameter filePath: filepath containing file whos name you want.
///
/// - returns: name of file with extension from given filepath.
public func fileNameFromFilePath(filePath: String) -> String {
    let filePathNSString = filePath as NSString
    return filePathNSString.lastPathComponent
}

/// Provides the filename of a filepath without extension.
///
/// - parameter filePath: filepath containing file whos name you want.
///
/// - returns: name of file without extension from given filepath.
public func fileNameFromFilePathWithoutExtension(filePath: String) -> String {
    let filePathNSString = filePath as NSString
    let fileNameWithExtension = filePathNSString.lastPathComponent as NSString
    return fileNameWithExtension.deletingPathExtension
}

/// Provides the directory of a filepath.
///
/// - parameter filePath: filepath containing file in a directory you want.
///
/// - returns: full directory path from given filepath. 
public func directoryFromFilePath(filePath: String) -> String {
    let filePathNSString = filePath as NSString
    let fileName = filePathNSString.lastPathComponent
    return filePathNSString.replacingOccurrences(of: fileName, with: "")
}

// MARK: - Private Static Functions

/// Prints error that occures during COFile operations
///
/// - parameter errorKind: FileManagerError reference to error that occured
/// - parameter error:     thrown error by operation
fileprivate func fileManagerError(errorKind: FileManagerError, error: Error) {
    print ("COFileManager - \(errorKind.rawValue) - \(error)")
}

/// Provides an array of file paths for files of a provided type at a specified bundle.
///
/// - parameter ofType: file types to be searching for.
/// - parameter bundle: bundle to search for these files for.
///
/// - returns: an array of files of the matching file type at the specified bundle.
fileprivate func pathsForResources(ofType: String, bundle: Bundle) -> [String] {
    return bundle.paths(forResourcesOfType: ofType, inDirectory: nil)
}
