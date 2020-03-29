//
//  PhotoPermissionRequester.swift
//  AVFoundationShowcase
//
//  Created by mickamy on 2020/03/29.
//  Copyright © 2020 mickamy. All rights reserved.
//

import UIKit
import Photos

public final class PhotoPermissionRequester: NSObject, PermissionRequester {
    public static var permission: PermissionType { .photo }

    public var status: PermissionStatus {
        .make(from: PHPhotoLibrary.authorizationStatus())
    }
    
    public func request(_ completion: @escaping (PermissionStatus) -> Void) {
        PHPhotoLibrary.requestAuthorization { result in
            completion(.make(from: result))
        }
    }
}

public protocol PhotoPermissionRequestable: PermissionRequestable {
    var photoPermissionRequester: PhotoPermissionRequester { get }
}

extension PhotoPermissionRequestable {
    static var permission: PermissionType { .photo }
    
    func presentPhotoDeniedAlert(_ okAction: @escaping () -> Void) {
        let alert = UIAlertController.alert(title: "You must permit this app save photos.")
        alert.addAction(.ok() { _ in okAction() })
        present(alert, animated: true, completion: nil)
    }
    
    func presentPhotoDisabledAlert(_ okAction: @escaping () -> Void) {
        let alert = UIAlertController.alert(title: "This device cannot save photos.")
        alert.addAction(.ok() { _ in okAction() })
        present(alert, animated: true, completion: nil)
    }
}

private extension PermissionStatus {
    static func make(from status: PHAuthorizationStatus) -> PermissionStatus {
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
