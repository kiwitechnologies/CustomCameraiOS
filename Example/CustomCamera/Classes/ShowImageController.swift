//
//  ResultImageControllerViewController.swift
//  CustomCamera
//
//  Created by Ayush on 5/4/16.
//  Copyright © 2016 Kiwitech. All rights reserved.
//

import UIKit

class ShowImageController: UIViewController {
    @IBOutlet private weak var _imageView:UIImageView!
    var _captureImage: UIImage!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.title = "Captured Image"
        _imageView.image = _captureImage
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(animated: Bool) {
      

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
