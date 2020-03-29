//
//  PermissionRequester.swift
//  AVFoundationShowcase
//
//  Created by mickamy on 2020/03/29.
//  Copyright © 2020 mickamy. All rights reserved.
//

import Foundation

public protocol PermissionRequester: NSObject {
    static var permission: PermissionType { get }
    
    var status: PermissionStatus { get }
    
    func request(_ completion: @escaping (PermissionStatus) -> Void)
}

extension PermissionRequester {
    var permission: PermissionType { Self.permission }
}

public enum PermissionStatus {
    case authorized
    case denied
    case disabled
    case notDetermined
}

public enum PermissionType {
    case camera
    case photo
}


public protocol PermissionRequestable: UIViewControllerPresentable {
    var permissionRequesters: [PermissionRequester] { get }
    
    func presentDeniedAlert(for permission: PermissionType, completion: (() -> Void)?)
    func presentDisabledAlert(for permission: PermissionType, completion: (() -> Void)?)
}

extension PermissionRequestable {
    public func requester(for permission: PermissionType) -> PermissionRequester {
        permissionRequesters.first(where: { type(of: $0).permission == permission })!
    }
    
    public func presentNotAuthorizedAlert(for permission: PermissionType, inStatus status: PermissionStatus, completion: (() -> Void)?) {
        switch status {
        case .authorized:
            fatalError("(\(permission) is authorized!")
        case .denied:
            presentDeniedAlert(for: permission, completion: completion)
        case .disabled:
            presentDisabledAlert(for: permission, completion: completion)
        case .notDetermined:
            fatalError("\(permission) is not determined")
        }
    }
}

extension PermissionRequestable where Self: CameraPermissionRequestable, Self: PhotoPermissionRequestable {
    public var permissionRequesters: [PermissionRequester] { [cameraPermissionRequester, photoPermissionRequester] }
    
    public func presentDeniedAlert(for permission: PermissionType, completion: (() -> Void)? = nil) {
        switch permission {
        case .camera:
            presentCameraDeniedAlert { completion?() }
        case .photo:
            presentPhotoDeniedAlert { completion?() }
        }
    }
    
    public func presentDisabledAlert(for permission: PermissionType, completion: (() -> Void)? = nil) {
        switch permission {
        case .camera:
            presentCameraDisabledAlert { completion?() }
        case .photo:
            presentPhotoDisabledAlert { completion?() }
        }
    }
}
