//
//  NibInstantiable.swift
//  avfoundation
//
//  Created by mickamy on 2020/03/28.
//  Copyright © 2020 mickamy. All rights reserved.
//

import UIKit

public protocol NibInstantiable {
    static var nibName: String { get }
}

extension NibInstantiable {
    public static var nibName: String { String(describing: self) }
}

extension NibInstantiable where Self: UIView {
    public func loadNib(bundle: Bundle? = nil) -> UIView {
        let bundle = bundle ?? Bundle(for: Self.self)
        return bundle.loadNibNamed(Self.nibName, owner: self, options: nil)!.first as! UIView
    }
}

extension UIView: NibInstantiable { }
