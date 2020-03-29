//
//  UIAlertController.ex.swift
//  AVFoundationShowcase
//
//  Created by mickamy on 2020/03/29.
//  Copyright © 2020 mickamy. All rights reserved.
//

import UIKit

public extension UIAlertController {
    static func alert(title: String? = nil, message: String? = nil) -> UIAlertController {
        UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
    }

    static func actionSheet(title: String? = nil, message: String? = nil) -> UIAlertController {
        UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.actionSheet)
    }
}
