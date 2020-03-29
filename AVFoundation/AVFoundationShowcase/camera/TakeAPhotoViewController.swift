//
//  TakeAPhotoViewController.swift
//  AVFoundationShowcase
//
//  Created by mickamy on 2020/03/28.
//  Copyright © 2020 mickamy. All rights reserved.
//

import UIKit
import AVFoundation

final class TakeAPhotoViewController: UIViewController, CameraPermissionRequestable, PhotoPermissionRequestable, PermissionRequestable {
    @IBOutlet private weak var previewView: CameraPreviewView!
    @IBOutlet private weak var capturedImageView: UIImageView! {
        didSet {
            capturedImageView.isHidden = true
        }
    }
    @IBOutlet private weak var overlayView: CameraOverlayView!
    @IBOutlet private weak var indicatorView: UIActivityIndicatorView! {
        didSet {
            indicatorView.isHidden = true
        }
    }
    
    private let sessionQueue = DispatchQueue(label: "camera session queue")
    
    private let session = AVCaptureSession()
    private let photoOutput = AVCapturePhotoOutput()
    
    private var captureProcessor: PhotoCaptureProcessor!
    
    private var isSessionRunning = false
    
    @objc dynamic var videoDeviceInput: AVCaptureDeviceInput!
    
    let cameraPermissionRequester = CameraPermissionRequester()
    let photoPermissionRequester = PhotoPermissionRequester()
    var permissionRequesters: [PermissionRequester] { [cameraPermissionRequester, photoPermissionRequester] }
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        previewView.session = session
        sessionQueue.async {
            self.configureSession()
        }
        
        indicatorView.hidesWhenStopped = true
        overlayView.didTapShutterButton = { [weak self] in self?.capturePhoto() }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        checkPermissions()
        
        sessionQueue.async {
            self.startSession()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        sessionQueue.async {
            self.stopSession()
        }
        super.viewWillDisappear(animated)
    }
    
    @IBAction
    private func didTapCancel(_ sender: Any) {
        dismiss(animated: true)
    }
}

private extension TakeAPhotoViewController {
    func checkPermissions() {
        for requester in permissionRequesters {
            let status = requester.status
            switch status {
            case .authorized:
                break
            case .denied, .disabled:
                sessionQueue.suspend()
                presentNotAuthorizedAlert(for: requester.permission, inStatus: status) { self.dismiss(animated: true) }
            case .notDetermined:
                self.sessionQueue.suspend()
                self.cameraPermissionRequester.request { result in
                    guard result == .authorized else {
                        self.sessionQueue.suspend()
                        return self.presentNotAuthorizedAlert(for: requester.permission, inStatus: result) { self.dismiss(animated: true) }
                    }
                    self.sessionQueue.resume()
                }
            }
        }
    }
}

private extension TakeAPhotoViewController {
    func configureSession() {
        session.beginConfiguration()
        defer {
            session.commitConfiguration()
        }
        session.sessionPreset = .photo
        
        configureVideo()
        configurePhoto()
    }
    
    private func configureVideo() {
        guard let device = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .back) else {
            return print("Default video device is unavailable.")
        }
        do {
            let input = try AVCaptureDeviceInput(device: device)
            guard session.canAddInput(input) else {
                return print("Couldn't add video device input to the session.")
            }
            session.addInput(input)
            self.videoDeviceInput = input
        } catch {
            print(error)
            return
        }
        
        DispatchQueue.main.async { [previewView] in
            previewView?.videoPreviewLayer.videoGravity = .resizeAspectFill
            previewView?.videoPreviewLayer.connection?.videoOrientation = .portrait
        }
    }
    
    private func configurePhoto() {
        guard session.canAddOutput(photoOutput) else {
            print("Could not add photo output to the session")
            return
        }

        session.addOutput(photoOutput)
        photoOutput.isHighResolutionCaptureEnabled = true
        photoOutput.isLivePhotoCaptureEnabled = photoOutput.isLivePhotoCaptureSupported
        photoOutput.isDepthDataDeliveryEnabled = photoOutput.isDepthDataDeliverySupported
    }
    
    func startSession() {
        session.startRunning()
        isSessionRunning = session.isRunning
    }
    
    func stopSession() {
        session.stopRunning()
        isSessionRunning = session.isRunning
    }
    
    func capturePhoto() {
        guard let orientation = previewView.videoPreviewLayer.connection?.videoOrientation else {
            fatalError()
        }
        sessionQueue.async { self._capturePhoto(withOrientation: orientation) }
        
    }
    
    private func _capturePhoto(withOrientation orientation: AVCaptureVideoOrientation) {
        let photoSettings = makePhotoSettings(input: videoDeviceInput, output: photoOutput)
        
        // The photo output holds a weak reference to the photo capture delegate and stores it in an array to maintain a strong reference.
        captureProcessor = PhotoCaptureProcessor(
            with: photoSettings,
            willCapturePhotoAnimation: {
                // Flash the screen to signal that app took a photo.
                DispatchQueue.main.async {
                    self.previewView.videoPreviewLayer.opacity = 0
                    UIView.animate(withDuration: 0.25) {
                        self.previewView.videoPreviewLayer.opacity = 1
                    }
                }
            },
            livePhotoCaptureHandler: { _ in
                // Do not support live photo
            },
            completionHandler: { photoCaptureProcessor in
                // When the capture is complete, remove a reference to the photo capture delegate so it can be deallocated.
                self.sessionQueue.async {
                    self.captureProcessor = nil
                }
            },
            photoProcessingHandler: { animate in
                // Animates a spinner while photo is processing
                DispatchQueue.main.async {
                    if animate {
                        self.indicatorView.hidesWhenStopped = true
                        self.indicatorView.startAnimating()
                    } else {
                        self.indicatorView.stopAnimating()
                    }
                }
            }
        )
        
        self.photoOutput.capturePhoto(with: photoSettings, delegate: captureProcessor)
    }
}

private func makePhotoSettings(input: AVCaptureDeviceInput, output: AVCapturePhotoOutput) -> AVCapturePhotoSettings {
    let settings: AVCapturePhotoSettings
    if output.availablePhotoCodecTypes.contains(.hevc) {
        settings = AVCapturePhotoSettings(format: [AVVideoCodecKey: AVVideoCodecType.hevc])
    } else {
        settings = AVCapturePhotoSettings()
    }
    if input.device.isFlashAvailable {
        settings.flashMode = .auto
    }
    settings.isAutoStillImageStabilizationEnabled = output.isStillImageStabilizationSupported
    
    settings.isHighResolutionPhotoEnabled = true
    if !settings.__availablePreviewPhotoPixelFormatTypes.isEmpty {
        settings.previewPhotoFormat = [kCVPixelBufferPixelFormatTypeKey as String: settings.__availablePreviewPhotoPixelFormatTypes.first!]
    }
    
    return settings
}
