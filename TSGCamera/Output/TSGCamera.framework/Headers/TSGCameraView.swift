//
//  CameraView.swift
//  KissCam
//
//  Copyright © 2016 kiwitech. All rights reserved.
//  Custom-Camera View

import UIKit
import AVFoundation

@objc public protocol CameraViewDelegate: class
{
    optional func cameraView(originalImage: UIImage, croppedImage: UIImage)
}


public class TSGCameraView: UIView {
    
    
    // AVFoundation properties
    private let captureSession =                 AVCaptureSession()
    private var captureDevice:                     AVCaptureDevice!
    private let stillImageOutput =      AVCaptureStillImageOutput()
    private var cameraLayer:            AVCaptureVideoPreviewLayer!
    private var currentDeviceOrienataion:   UIInterfaceOrientation!
    
    
    // CLASS VARIABLES
    
    //Set Camera Quality
    public var outPutQuality: CameraOutputQuality =    CameraOutputQuality.High
    //Read Camera State
    public var cameraState:CameraState = CameraState.NotDetermined
    //Set Camera Front/Back
    public var cameraPosition:CameraDevicePosition = CameraDevicePosition.Back
    //Set Camera Flash Mode
    public var flashMode: FlashMode {
        didSet
        {
            if(cameraState == CameraState.Authorized)
            {
                TSGCameraHelper.setFlashMode(flashMode,device:captureDevice)
            }
            else
            {
                print("Camera Permissions are not authorized")
            }
        }
    }
    //Set Camera Torch Mode
    public var torchMode: TorchMode {
        didSet
        {
            if(cameraState == CameraState.Authorized)
            {
                TSGCameraHelper.setTorchMode(torchMode,device:captureDevice)
            }
            else
            {
                print("Camera Permissions are not authorized")
            }
        }
    }
    
    public weak var delegate: CameraViewDelegate?
    
    //MARK- INIT Methods
    override init (frame : CGRect)
    {
        flashMode = FlashMode.Auto
        torchMode = TorchMode.Off
        super.init(frame : frame)
    }
    
    
    required public init?(coder aDecoder: NSCoder)
    {
        flashMode = FlashMode.Auto
        torchMode = TorchMode.Off
        super.init(coder: aDecoder)
        initCamera()
    }
    
    /*
     *	@functionName	: encryptObjectWithSuccess
     *	This method is used to initialize the Camera.
     * */
    
    public func initCamera()
    {
        currentDeviceOrienataion = UIApplication.sharedApplication().statusBarOrientation
        cameraState = TSGCameraHelper.getCameraStatus(self)
        if(cameraState == CameraState.Authorized || cameraState == CameraState.NotDetermined)
        {
            captureSession.beginConfiguration()
            self.startCameraSession(cameraPosition)
        }
    }
    
    /*
     *	@functionName	: stopCameraSession
     *  This method is used to stop the camera session.
     * */
    
    public func stopCameraSession()
    {
        if captureSession.running
        {
            captureSession.stopRunning()
            cameraLayer?.removeFromSuperlayer()
            captureSession.removeInput((captureSession.inputs as NSArray).objectAtIndex(0) as! AVCaptureInput)
        }
    }
    
    /*
     *	@functionName	: toggleTorchMode
     *  This method is used to ON/OFF the camera torch.
     * */
    
    public func toggleTorchMode()
    {
        if torchMode == TorchMode.On
        {
            self.torchMode = TorchMode.Off
        }
        else
        {
            self.torchMode = TorchMode.On
        }
        
    }
    
    /*
     *	@functionName	: flipCamera
     *  This method is used to flip camera between Front/Back.
     * */
    public func flipCamera()
    {
        if(cameraState == CameraState.Authorized)
        {
            
            if cameraPosition == CameraDevicePosition.Back
            {
                cameraPosition = CameraDevicePosition.Front
            }
            else
            {
                cameraPosition = CameraDevicePosition.Back
            }
            self.startCameraSession(cameraPosition)
        }
        else
        {
            print("Camera Permissions are not authorized")
        }
    }
    
    //Mark:- Method To Get Original Image Dispalyed On View
    /*
     *	@functionName	: captureImage
     *  This method is used to capture the image.
     * */
    public func captureImage()
    {
        if let videoConnection = self.stillImageOutput.connectionWithMediaType(AVMediaTypeVideo)
        {
            videoConnection.videoOrientation   = TSGCameraHelper.videoOrientationForDeviceOrientation(UIDevice.currentDevice().orientation)
            self.stillImageOutput.captureStillImageAsynchronouslyFromConnection(videoConnection, completionHandler: { (buffer:CMSampleBuffer!, error: NSError!) -> Void in
                var originalImage:UIImage!
                var cropImage:UIImage!
                if (buffer != nil)
                {
                    let imageData = AVCaptureStillImageOutput.jpegStillImageNSDataRepresentation(buffer)
                    originalImage = UIImage(data: imageData)!
                    let outputRect = self.cameraLayer?.metadataOutputRectOfInterestForRect(self.cameraLayer!.bounds)
                    cropImage = TSGCameraHelper.cropImageInRect(originalImage, outputRect: outputRect)
                }
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    
                    if (self.delegate != nil && originalImage != nil)
                    {
                        self.delegate?.cameraView!(originalImage, croppedImage: cropImage)
                    }
                })
            })
        }
        else
        {
            print("Camera Permissions are not authorized")
        }
    }
    
    /*
     *	@functionName	: setFocusWithISOValue
     *  This method is used to set the camera focus.
     * */
    public func setFocusWithISOValue(focusValue : Float, isoValue : Float)
    {
        if let device = captureDevice
        {
            TSGCameraHelper.setFocusWithISOValue(device, focusValue: focusValue, isoValue: isoValue)
        }
    }
    
    
    /*
     *	@functionName	: setFocusWithLensPosition
     *	@parameters		: position : Lens Position
     *  This method is used to set the camera lens position.
     * */
    public func setFocusWithLensPosition(position: CFloat)
    {
        if let device = captureDevice
        {
            TSGCameraHelper.setFocusWithLensPosition(device, pos: position)
        }
    }
    
    
    /*
     *	@functionName	: startCameraSession
     *	@parameters		: position : It would decide whether to show front/back camera
     *  This method is used to start the camera session in the specified camera position.
     * */
    private func startCameraSession(position: CameraDevicePosition)
    {
        self.stopCameraSession()
        let device: AVCaptureDevice! = TSGCameraHelper.cameraDeviceForPosition(position)
        captureDevice = device
        let error: NSErrorPointer = nil
        do
        {
            try captureDevice!.lockForConfiguration()
        } catch let error1 as NSError
        {
            error.memory = error1
        }
        
        
        var deviceInput: AVCaptureDeviceInput!
        do {
            deviceInput = try AVCaptureDeviceInput(device: captureDevice)
        } catch let error1 as NSError {
            error.memory = error1
            deviceInput = nil
        }
        
        if(error == nil && captureSession.canAddInput(deviceInput))
        {
            captureSession.addInput(deviceInput)
        }
        if(captureSession.canAddOutput(stillImageOutput))
        {
            stillImageOutput.outputSettings = [AVVideoCodecKey: AVVideoCodecJPEG]
            captureSession.addOutput(stillImageOutput)
        }
        self.setCameraQuality()
        
        // setup camera preview
        cameraLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        
        if let player = cameraLayer
        {
            player.videoGravity = AVLayerVideoGravityResizeAspectFill
            self.layer.addSublayer(player)
            self.changeCameraOrienataion(currentDeviceOrienataion!)
        }
        captureSession.commitConfiguration()
        captureSession.startRunning()
        TSGCameraHelper.setFlashMode(flashMode,device:captureDevice)
    }
    
    /*
     *	@functionName	: updateCameraState
     *	@parameters		: lcameraState : Camera State
     *  This method is used to set the camera state.
     * */
    internal func updateCameraState(lcameraState:CameraState )
    {
        cameraState = lcameraState
    }
    
    
    /*
     *	@functionName	: changeCameraOrienataion
     *	@parameters		: orientation : It take device orientation as the input.
     *  This method is used to change the current camera orientation depending on device orientation.
     * */
    private func changeCameraOrienataion(orientation: UIInterfaceOrientation)
    {
        if let player = cameraLayer
        {
            player.frame = self.layer.bounds
            TSGCameraHelper.changeCameraOrienataion(player, orientation: orientation)
        }
    }
    
    
    /*
     *	@functionName	: setCameraQuality
     *  This method is used to change the camera session quality.
     * */
    private func setCameraQuality()
    {
        switch outPutQuality
        {
        case  .Low:
            captureSession.sessionPreset = AVCaptureSessionPresetLow
            
        case    .Medium:
            captureSession.sessionPreset = AVCaptureSessionPresetMedium
            
        case .High:
            captureSession.sessionPreset = AVCaptureSessionPresetHigh
        }
    }
}




