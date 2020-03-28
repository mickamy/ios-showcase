//
//  ViewController.swift
//  avfoundation
//
//  Created by mickamy on 2020/03/28.
//  Copyright © 2020 mickamy. All rights reserved.
//

import UIKit

final class ViewController: UIViewController {
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func didTapTakeAPhotoButton(_ sender: Any) {
        let destination = TakeAPhotoViewController()
        destination.modalPresentationStyle = .fullScreen
        present(destination, animated: true)
    }
}
