//
//  CameraPreviewView.swift
//  AVFoundationShowcase
//
//  Created by mickamy on 2020/03/28.
//  Copyright © 2020 mickamy. All rights reserved.
//

import UIKit
import AVFoundation

@IBDesignable
final class CameraPreviewView: UIView {
    var videoPreviewLayer: AVCaptureVideoPreviewLayer {
        guard let layer = layer as? AVCaptureVideoPreviewLayer else {
            fatalError("Expected `\(AVCaptureVideoPreviewLayer.self)` type for layer. Check `\(Self.self).layerClass` implementation.")
        }
        return layer
    }
    
    var session: AVCaptureSession? {
        get { videoPreviewLayer.session }
        set { videoPreviewLayer.session = newValue }
    }
    
    override class var layerClass: AnyClass {
        return AVCaptureVideoPreviewLayer.self
    }
}
