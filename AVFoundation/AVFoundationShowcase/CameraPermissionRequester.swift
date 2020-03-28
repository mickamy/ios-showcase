//
//  CameraPermissionRequester.swift
//  AVFoundationShowcase
//
//  Created by mickamy on 2020/03/29.
//  Copyright © 2020 mickamy. All rights reserved.
//

import UIKit
import AVFoundation

final class CameraPermissionRequester: NSObject, PermissionRequester {
    var status: PermissionStatus {
        .make(from: AVCaptureDevice.authorizationStatus(for: .video))
    }
    
    func request(_ completion: @escaping (PermissionStatus) -> Void) {
        AVCaptureDevice.requestAccess(for: .video) { granted in
            completion(granted ? .authorized : .notAuthorized)
        }
    }
}

protocol CameraPermissionRequestable: UIViewControllerPresentable {
    var cameraPermissionRequester: CameraPermissionRequester { get }
}

extension CameraPermissionRequestable {
    func withCameraPermission(_ closure: @escaping () -> Void) {
        switch cameraPermissionRequester.status {
        case .authorized:
            closure()
        case .notAuthorized:
            DispatchQueue.main.async {
                self.presentCameraNotAuthorizedAlert()
            }
        case .notDetermined:
            cameraPermissionRequester.request { result in
                guard result == .authorized else {
                    return DispatchQueue.main.async { self.presentCameraNotAuthorizedAlert() }
                }
                closure()
            }
        }
    }
    
    func presentCameraNotAuthorizedAlert() {
        let alert = UIAlertController.alert(title: "You must permit this app to use Camera.")
        alert.addAction(.ok())
        present(alert, animated: true, completion: nil)
    }
}

private extension PermissionStatus {
    static func make(from status: AVAuthorizationStatus) -> PermissionStatus {
        switch status {
        case .authorized:
            return .authorized
        case .denied, .restricted:
            return .notAuthorized
        case .notDetermined:
            return .notDetermined
        @unknown default:
            return .notAuthorized
        }
    }
}
