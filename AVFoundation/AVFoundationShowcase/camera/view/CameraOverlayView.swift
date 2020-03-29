//
//  CameraOverlayView.swift
//  AVFoundationShowcase
//
//  Created by mickamy on 2020/03/28.
//  Copyright © 2020 mickamy. All rights reserved.
//

import UIKit

@IBDesignable
final class CameraOverlayView: UIView {
    @IBOutlet private weak var shutterButton: UIButton!
    
    var didTapShutterButton: (() -> Void)? = nil
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    private func commonInit() {
        let view = loadNib()
        addSubview(view)
        view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            view.topAnchor.constraint(equalTo: topAnchor),
            view.leadingAnchor.constraint(equalTo: leadingAnchor),
            view.trailingAnchor.constraint(equalTo: trailingAnchor),
            view.bottomAnchor.constraint(equalTo: bottomAnchor),
        ])
        
        shutterButton.addTarget(self, action: #selector(Self.didTapShutterButton(sender:)), for: .touchUpInside)
    }
    
    @objc private func didTapShutterButton(sender: UIButton) {
        didTapShutterButton?()
    }
}
