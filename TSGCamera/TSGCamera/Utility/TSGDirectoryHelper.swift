//
//  DirectoryHelper.swift
//  CustomCamera
//
//  Created by Ayush on 5/2/16.
//  Copyright © 2016 Kiwitech. All rights reserved.
//

//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to
//  deal in the Software without restriction, including without limitation the
//  rights to use, copy, modify, merge, publish, distribute, sublicense, and/or
//  sell copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS
//  OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
//  WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR
//  IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

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
