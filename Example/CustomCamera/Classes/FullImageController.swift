//
//  CropViewController.swift
//  CustomCamera
//
//  Created by Ayush on 5/5/16.
//  Copyright © 2016 Kiwitech. All rights reserved.
//

import UIKit

class FullImageController: UIViewController,TOCropViewControllerDelegate
{
    @IBOutlet private weak var _imageView:UIImageView!
    var _captureImage: UIImage!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Full Image"
        _imageView.image = _captureImage

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func cropClicked(sender: UIButton)
    {
        let cropController:TOCropViewController = TOCropViewController(image: _captureImage)
        cropController.delegate = self
        cropController.defaultAspectRatio = TOCropViewControllerAspectRatio.RatioSquare
        cropController.aspectRatioLocked = true
        cropController.toolbar.hidden = false
        self.presentViewController(cropController, animated: true, completion: nil)

    }
    
    func cropViewController(cropViewController: TOCropViewController!, didCropToImage image: UIImage!, withRect cropRect: CGRect, angle: Int)
    {
        _imageView.image = image
        cropViewController.dismissViewControllerAnimated(true, completion: nil)
    }


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
