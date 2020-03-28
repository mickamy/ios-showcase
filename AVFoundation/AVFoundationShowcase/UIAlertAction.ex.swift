//
//  UIAlertAction.ex.swift
//  AVFoundationShowcase
//
//  Created by mickamy on 2020/03/29.
//  Copyright © 2020 mickamy. All rights reserved.
//


import UIKit

public extension UIAlertAction {
    typealias Handler = (UIAlertAction) -> Void

    static func `default`(title: String? = nil, handler: Handler? = nil) -> UIAlertAction {
        UIAlertAction(
            title: title,
            style: UIAlertAction.Style.default,
            handler: handler
        )
    }

    static func cancel(title: String = "Cancel", handler: Handler? = nil) -> UIAlertAction {
        UIAlertAction(
            title: title,
            style: UIAlertAction.Style.cancel,
            handler: handler
        )
    }

    static func destructive(title: String? = nil, handler: Handler? = nil) -> UIAlertAction {
        UIAlertAction(
            title: title,
            style: UIAlertAction.Style.destructive,
            handler: handler
        )
    }

    static func ok(handler: Handler? = nil) -> UIAlertAction {
        UIAlertAction.default(title: "OK", handler: handler)
    }

    static func yes(handler: Handler? = nil) -> UIAlertAction {
        UIAlertAction.default(title: "Yes", handler: handler)
    }

    static func no(handler: Handler? = nil) -> UIAlertAction {
        UIAlertAction.cancel(title: "No", handler: handler)
    }
}
