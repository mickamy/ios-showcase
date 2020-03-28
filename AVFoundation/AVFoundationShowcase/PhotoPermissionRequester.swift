//
//  PhotoPermissionRequester.swift
//  AVFoundationShowcase
//
//  Created by mickamy on 2020/03/29.
//  Copyright © 2020 mickamy. All rights reserved.
//

import UIKit
import Photos

final class PhotoPermissionRequester: NSObject, PermissionRequester {
    var status: PermissionStatus {
        .make(from: PHPhotoLibrary.authorizationStatus())
    }
    
    func request(_ completion: @escaping (PermissionStatus) -> Void) {
        PHPhotoLibrary.requestAuthorization { result in
            completion(.make(from: result))
        }
    }
}

protocol PhotoPermissionRequestable: UIViewControllerPresentable {
    var photoPermissionRequester: PhotoPermissionRequester { get }
}

extension PhotoPermissionRequestable {
    func withPhotoPermission(_ closure: @escaping () -> Void) {
        switch photoPermissionRequester.status {
        case .authorized:
            closure()
        case .notAuthorized:
            DispatchQueue.main.async {
                self.presentPhotoNotAuthorizedAlert()
            }
        case .notDetermined:
            photoPermissionRequester.request { result in
                guard result == .authorized else {
                    return DispatchQueue.main.async { self.presentPhotoNotAuthorizedAlert() }
                }
                closure()
            }
        }
    }
    
    func presentPhotoNotAuthorizedAlert() {
        let alert = UIAlertController.alert(title: "You must permit this app save photos.")
        alert.addAction(.ok())
        present(alert, animated: true, completion: nil)
    }
}

private extension PermissionStatus {
    static func make(from status: PHAuthorizationStatus) -> PermissionStatus {
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
