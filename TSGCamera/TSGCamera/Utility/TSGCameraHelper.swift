//
//  CameraHelper.swift
//  CustomCamera
//
//  Created by Ayush on 5/2/16.
//  Copyright © 2016 Kiwitech. All rights reserved.
//

import UIKit
import AVFoundation

class TSGCameraHelper: NSObject
{
    

    //MARK:- Camera Methods
    internal class func getCameraStatus(cameraView:TSGCameraView) ->CameraState
    {
        let authStatus = AVCaptureDevice.authorizationStatusForMediaType(AVMediaTypeVideo)
        switch authStatus
        {
        case .Authorized:
            return CameraState.Authorized
        case .Denied:
            return  CameraState.AccessDenied
        case .NotDetermined:
                AVCaptureDevice.requestAccessForMediaType(AVMediaTypeVideo, completionHandler: { (granted) -> Void in
                    if granted
                    {
                         cameraView.updateCameraState(CameraState.Authorized)
                    }
                    else
                    {
                        cameraView.updateCameraState(CameraState.AccessDenied)
                    }
                })
            return CameraState.NotDetermined
        case .Restricted:
            return CameraState.Restricted
        }
    }
    
    internal class func cameraDeviceForPosition(position:CameraDevicePosition) -> AVCaptureDevice?
    {
        let cameraPosition:AVCaptureDevicePosition
        if position == CameraDevicePosition.Back
        {
            cameraPosition = AVCaptureDevicePosition.Back
        }
        else
        {
            cameraPosition = AVCaptureDevicePosition.Front
        }
        
        for device:AnyObject in AVCaptureDevice.devices() {
            if (device.position == cameraPosition)
            {
                
                return device as? AVCaptureDevice;
            }
        }
        
        return nil
    }
    
    
    internal class func cropImageInRect(originalImage:UIImage!,outputRect:CGRect! ) -> UIImage
    {
        let takenCGImage = originalImage.CGImage
        let width:CGFloat =  CGFloat(CGImageGetWidth(takenCGImage))
        let height:CGFloat =  CGFloat(CGImageGetHeight(takenCGImage))
        let  cropRect = CGRectMake(outputRect!.origin.x * width, outputRect!.origin.y * height, outputRect!.size.width * width, outputRect!.size.height * height);
        let cropCGImage = CGImageCreateWithImageInRect(takenCGImage, cropRect)
        let cropImage = UIImage(CGImage: cropCGImage!, scale: 1.0, orientation:originalImage.imageOrientation)
        return cropImage
    }
    
//MARK:- Get Orienataion Of Video Track
   internal class func orientationForTrack(asset:AVAsset)->UIInterfaceOrientation
    {
        let clipVideoTrack: AVAssetTrack  = (asset.tracksWithMediaType(AVMediaTypeVideo) as NSArray).objectAtIndex(0) as! AVAssetTrack
        
        let size: CGSize = clipVideoTrack.naturalSize
        
        let txf: CGAffineTransform = clipVideoTrack.preferredTransform
        
        if (size.width == txf.tx && size.height == txf.ty)
        {
            return UIInterfaceOrientation.LandscapeLeft
        }
        else if (txf.tx == 0 && txf.ty == 0)
        {
            return UIInterfaceOrientation.LandscapeRight
        }
        else if (txf.tx == 0 && txf.ty == size.width)
        {
            return UIInterfaceOrientation.PortraitUpsideDown
        }
        else
        {
            return UIInterfaceOrientation.Portrait
        }
    }
    
    internal class func changeCameraOrienataion(cameraLayer:AVCaptureVideoPreviewLayer!, orientation: UIInterfaceOrientation)
    {
            switch orientation
            {
            case UIInterfaceOrientation.Portrait :
                cameraLayer.connection.videoOrientation = AVCaptureVideoOrientation.Portrait
                
            case UIInterfaceOrientation.LandscapeLeft :
                cameraLayer.connection.videoOrientation = AVCaptureVideoOrientation.LandscapeLeft
                
            case UIInterfaceOrientation.LandscapeRight :
                cameraLayer.connection.videoOrientation = AVCaptureVideoOrientation.LandscapeRight
                
            case UIInterfaceOrientation.PortraitUpsideDown :
                cameraLayer.connection.videoOrientation = AVCaptureVideoOrientation.PortraitUpsideDown
                
            default:
                cameraLayer.connection.videoOrientation = AVCaptureVideoOrientation.Portrait
            }
    }

    
   internal class func videoOrientationForDeviceOrientation(deviceOrientation:UIDeviceOrientation)->AVCaptureVideoOrientation
    {
        var result: AVCaptureVideoOrientation  = AVCaptureVideoOrientation.Portrait ;
        
        switch (deviceOrientation) {
        case .LandscapeLeft:
            result = AVCaptureVideoOrientation.LandscapeRight;
            break;
            
        case .LandscapeRight:
            result = AVCaptureVideoOrientation.LandscapeLeft;
            break;
            
        default:
            break;
        }
        
        return result;
    }

//MARK:- SET Flash/Torch

    internal class func setFlashMode(flashMode:FlashMode, device: AVCaptureDevice!)
    {
        switch flashMode
        {
            
        case .Off:
            if(device.isFlashModeSupported(AVCaptureFlashMode.Off))
            {
                device.flashMode = AVCaptureFlashMode.Off
            }
            break
        case .On:
            if(device.isFlashModeSupported(AVCaptureFlashMode.On))
            {
                device.flashMode = AVCaptureFlashMode.On

            }
            break
        case .Auto:
            if(device.isFlashModeSupported(AVCaptureFlashMode.Auto))
            {
                device.flashMode = AVCaptureFlashMode.Auto
            }
            break
        }
    }
    
    internal class func setTorchMode(torchMode:TorchMode, device: AVCaptureDevice!)
    {
        switch torchMode
        {
            
        case .Off:
            if(device.isTorchModeSupported(AVCaptureTorchMode.Off))
            {
                device.torchMode = AVCaptureTorchMode.Off
            }
            break
        case .On:
            if(device.isTorchModeSupported(AVCaptureTorchMode.On))
            {
                device.torchMode = AVCaptureTorchMode.On
                
            }
            break
        case .Auto:
            if(device.isTorchModeSupported(AVCaptureTorchMode.Auto))
            {
                device.torchMode = AVCaptureTorchMode.Auto
            }
            break
        }
    }
    
    //MARK:- Set Focus
    
    internal class func setFocusWithISOValue(captureDevice:AVCaptureDevice!, focusValue : Float, isoValue : Float)
    {
        let error: NSErrorPointer = nil
        do
        {
            try captureDevice!.lockForConfiguration()
        } catch let error1 as NSError {
            error.memory = error1
        }
        captureDevice.setFocusModeLockedWithLensPosition(focusValue, completionHandler: { (time) -> Void in})
        
            // Adjust the iso to clamp between minIso and maxIso based on the active format
        let minISO = captureDevice.activeFormat.minISO
        let maxISO = captureDevice.activeFormat.maxISO
        let clampedISO = isoValue * (maxISO - minISO) + minISO
            
        captureDevice.setExposureModeCustomWithDuration(AVCaptureExposureDurationCurrent, ISO: clampedISO, completionHandler: { (time) -> Void in
                //
        })
        captureDevice.unlockForConfiguration()
    }
    
    
    internal class func setFocusWithLensPosition(captureDevice:AVCaptureDevice!, pos: CFloat)
    {
        let error: NSErrorPointer = nil
        do {
            try captureDevice!.lockForConfiguration()
        } catch let error1 as NSError {
            error.memory = error1
        }
        captureDevice!.setFocusModeLockedWithLensPosition(pos, completionHandler: nil)
        captureDevice!.unlockForConfiguration()
    }


  }
