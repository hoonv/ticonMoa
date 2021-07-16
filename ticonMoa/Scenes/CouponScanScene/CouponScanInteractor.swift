//
//  CouponScanInteractor.swift
//  ticonMoa
//
//  Created by 채훈기 on 2021/07/09.
//  Copyright (c) 2021 hoon. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit
import Vision

protocol CouponScanBusinessLogic {
    func scanPhoto(request: CouponScan.PhotoScan.Request)
}

protocol CouponScanDataStore {
    var image: UIImage? { get set }
}

class CouponScanInteractor: CouponScanBusinessLogic, CouponScanDataStore {
    var presenter: CouponScanPresentationLogic?
    var worker: CouponScanWorker?
    var image: UIImage?
    let manager = OCRManager()
    // MARK: Do something
    
    func scanPhoto(request: CouponScan.PhotoScan.Request) {
        worker = CouponScanWorker()
        worker?.doSomeWork()

        let requestHandler = VNImageRequestHandler(cgImage: image!.cgImage!)
        let request = VNRecognizeTextRequest(completionHandler: recognizeTextHandler)
        do {
            try requestHandler.perform([request])
        } catch {
            print("Error")
        }

    }
    
    func recognizeTextHandler(request: VNRequest, error: Error?) {
        guard let results = request.results as? [VNRecognizedTextObservation] else { return }
        
        for result in results {
            
            guard let payload = result.topCandidates(1).first?.string else {  continue }
            var transform = CGAffineTransform.identity
            transform = transform.scaledBy(x: image!.size.width, y: -image!.size.height)
            transform = transform.translatedBy(x: 0, y: -1)
            let rect = result.boundingBox.applying(transform)

            guard let cropped = image!.crop(rect: rect) else { continue }
            
            let p: [String] = manager.requestTextRecognition(image: cropped)
            print(p)
        }

        
        let response = CouponScan.PhotoScan.Response(boxes: [])
        presenter?.presentScanResult(response: response)
    }
    
    func imageHandler(image: UIImage, pay: OCRManager.Payload) {
        print(pay)
    }
}
