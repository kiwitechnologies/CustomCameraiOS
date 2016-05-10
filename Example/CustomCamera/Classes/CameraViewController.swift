//
//  ViewController.swift
//  CustomCamera
//
//  Created by Ayush on 4/22/16.
//  Copyright © 2016 Kiwitech. All rights reserved.
//

import UIKit
import TSGCamera


class CameraViewController: UIViewController, CameraViewDelegate
{
    @IBOutlet private weak var cameraContainer: UIView!
    var cameraView: TSGCameraView!
    @IBOutlet private weak var selectedButton:UIButton!
    @IBOutlet private weak var offButton:UIButton!
    var cropMode = false
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        self.view.layoutIfNeeded()
        cameraView = TSGCameraView()
        cameraView.frame = CGRectMake(0, 0, cameraContainer.frame.size.width, cameraContainer.frame.size.height)
        cameraContainer.addSubview(cameraView)
        cameraView.delegate = self
        cameraView.initCamera() 
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    func cameraView(originalImage: UIImage, croppedImage: UIImage)
    {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
      
        if(cropMode == false)
        {
              let controller:ShowImageController! = storyboard.instantiateViewControllerWithIdentifier("ShowImageController") as! ShowImageController
            controller._captureImage = croppedImage
            self.navigationController?.pushViewController(controller, animated: true)
        }
        else
        {
              let controller:FullImageController! = storyboard.instantiateViewControllerWithIdentifier("FullImageController") as! FullImageController
            controller._captureImage = originalImage
            self.navigationController?.pushViewController(controller, animated: true)
        }

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func cameraClicked(sender: AnyObject)
    {
        cropMode = false
        cameraView.captureImage()
    }
    
    @IBAction func clickCropClicked(sender: AnyObject)
    {
        cropMode = true
        cameraView.captureImage()
    }
    
    @IBAction func flipCamera(sender: AnyObject)
    {
        cameraView.flipCamera()
        selectedButton.selected = false
        offButton.selected =  true
        cameraView.flashMode = FlashMode.Off
    }
    
    @IBAction func setFlashMode(sender: UIButton)
    {
        selectedButton.selected = false
        selectedButton = sender
        selectedButton.selected = true
        
        switch selectedButton.tag
        {
            
        case FlashMode.Off.rawValue:
            cameraView.flashMode = FlashMode.Off
            break
        case FlashMode.On.rawValue:
            cameraView.flashMode = FlashMode.On
            break
        default:
            cameraView.flashMode = FlashMode.Auto
            break
        }
    }
    
    @IBAction func setTorch(sender: UIButton)
    {
        sender.selected = !sender.selected
        cameraView.toggleTorchMode()
    }


}

