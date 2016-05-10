//
//  DirectoryHelper.swift
//  CustomCamera
//
//  Created by Ayush on 5/2/16.
//  Copyright © 2016 Kiwitech. All rights reserved.
//

import UIKit
import AVFoundation

class TSGDirectoryHelper: NSObject {

    
    //MARK:- File Manager Methods
    internal class func getFolderPathOfName(folderName : String)-> NSURL
    {
        // The directory the application uses to store the Core Data store file. This code uses a directory named
        let documentsPath = NSURL(fileURLWithPath: NSSearchPathForDirectoriesInDomains(.CachesDirectory, .UserDomainMask, true)[0])
        let folderPath = documentsPath.URLByAppendingPathComponent(folderName)
        do
        {
            try NSFileManager.defaultManager().createDirectoryAtPath(folderPath.path!, withIntermediateDirectories: true, attributes: nil)
        }
        catch let error as NSError
        {
            NSLog("Unable to create directory \(error.debugDescription)")
        }
        return folderPath
    }
    internal class func getFilePathInFolder(imageName:String, folderName foldername: String)->NSURL
    {
        let folderPath = TSGDirectoryHelper.getFolderPathOfName(foldername)
        let filePath = folderPath.URLByAppendingPathComponent(imageName)
        return filePath
    }
    
    internal class func removeItemFromCurrentURL(fileURL:NSURL!)
    {
        if NSFileManager.defaultManager().fileExistsAtPath(fileURL!.relativePath!)
        {
            do
            {
                try NSFileManager.defaultManager().removeItemAtURL(fileURL!)
            }catch let error as NSError
            {
                print(error)
            }
        }
        
        
    }
}
