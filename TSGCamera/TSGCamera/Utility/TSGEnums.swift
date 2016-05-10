
//
//  Enums.swift
//  CustomCamera
//
//  Created by Ayush on 4/28/16.
//  Copyright © 2016 Kiwitech. All rights reserved.
//


public enum CameraState
{
    case Authorized, AccessDenied, NotDetermined, Restricted
}

public enum CameraDevicePosition
{
    case Front, Back
}

public enum CameraFlashMode: Int
{
    case Off, On, Auto
}


public enum CameraOutputQuality: Int
{
    case Low, Medium, High
}

public enum FlashMode : Int {
    
    case Off
    case On
    case Auto
}

public enum TorchMode : Int {
    
    case Off
    case On
    case Auto
}

