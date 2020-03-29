//
//  CameraPermissionRequester.swift
//  AVFoundationShowcase
//
//  Created by mickamy on 2020/03/29.
//  Copyright © 2020 mickamy. All rights reserved.
//

import UIKit
import AVFoundation

public final class CameraPermissionRequester: NSObject, PermissionRequester {
    public static var permission: PermissionType { .camera }
    
    public var status: PermissionStatus {
        .make(from: AVCaptureDevice.authorizationStatus(for: .video))
    }
    
    public func request(_ completion: @escaping (PermissionStatus) -> Void) {
        AVCaptureDevice.requestAccess(for: .video) { granted in
            completion(granted ? .authorized : .denied)
        }
    }
}

public protocol CameraPermissionRequestable: UIViewControllerPresentable {
    var cameraPermissionRequester: CameraPermissionRequester { get }
}

extension CameraPermissionRequestable {
    func presentCameraDeniedAlert(_ okAction: @escaping () -> Void) {
        let alert = UIAlertController.alert(title: "You must permit this app to use camera.")
        alert.addAction(.ok() { _ in okAction() })
        present(alert, animated: true, completion: nil)
    }
    
    func presentCameraDisabledAlert(_ okAction: @escaping () -> Void) {
        let alert = UIAlertController.alert(title: "This device does not support camera.")
        alert.addAction(.ok() { _ in okAction() })
        present(alert, animated: true, completion: nil)
    }
}

private extension PermissionStatus {
    static func make(from status: AVAuthorizationStatus) -> PermissionStatus {
        switch status {
        case .authorized:
            return .authorized
        case .denied:
            return .denied
        case .restricted:
            return .disabled
        case .notDetermined:
            return .notDetermined
        @unknown default:
            return .denied
        }
    }
}
