//
//  PermissionRequester.swift
//  AVFoundationShowcase
//
//  Created by mickamy on 2020/03/29.
//  Copyright © 2020 mickamy. All rights reserved.
//

import Foundation

protocol PermissionRequester: NSObject {
    var status: PermissionStatus { get }
    
    func request(_ completion: @escaping (PermissionStatus) -> Void)
}

enum PermissionStatus {
    case authorized
    case notAuthorized
    case notDetermined
}
