//
//  TakeAPhotoViewController.swift
//  AVFoundationShowcase
//
//  Created by mickamy on 2020/03/28.
//  Copyright © 2020 mickamy. All rights reserved.
//

import UIKit

final class TakeAPhotoViewController: UIViewController {
    @IBOutlet private weak var cameraOutputView: UIView!
    @IBOutlet private weak var capturedImageView: UIImageView!
    @IBOutlet private weak var overlayView: CameraOverlayView!
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
