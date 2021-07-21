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
    func scanPhoto(request: CouponScan.ScanPhoto.Request)
    func registerCoupon(request: CouponScan.RegisterCoupon.Request)
}

protocol CouponScanDataStore {
    var image: UIImage? { get set }
}

class CouponScanInteractor: CouponScanBusinessLogic, CouponScanDataStore {
    var presenter: CouponScanPresentationLogic?
    var worker: CouponScanWorker?
    let manager = OCRManager()
    
    // MARK: DataStore
    
    var image: UIImage?

    // MARK: Scan Photo
    
    func scanPhoto(request: CouponScan.ScanPhoto.Request) {
        let requestHandler = VNImageRequestHandler(cgImage: image!.cgImage!)
        let request = VNRecognizeTextRequest(completionHandler: recognizeTextHandler)
        try? requestHandler.perform([request])
    }
    
    // MARK: Register Coupon
    
    func registerCoupon(request: CouponScan.RegisterCoupon.Request) {
        worker = CouponScanWorker()
        let result = worker?.isVaildCoupon(request: request)
        
        switch result {
        case .success:
            worker?.saveCouponToCoreData(request: request)
            worker?.saveCouponImage(name: request.barcode, image: image)
            presenter?.finishCouponSave()
        case .dateFormatError:
            let msg = "날짜의 형식이 맞지 않습니다."
            presenter?.presentAlert(response: .init(title: nil, message: msg))
        case .inputValueError:
            let msg = "빈칸을 모두 입력하세요"
            presenter?.presentAlert(response: .init(title: nil, message: msg))
        case .none:
            print("nil")
        }
    }
    
    func recognizeTextHandler(request: VNRequest, error: Error?) {
        guard let results = request.results as? [VNRecognizedTextObservation],
              results.count < 15 else { return }
        
        let recognized = results.map { result -> [String] in
            var transform = CGAffineTransform.identity
            transform = transform.scaledBy(x: image!.size.width, y: -image!.size.height)
            transform = transform.translatedBy(x: 0, y: -1)
            let rect = result.boundingBox.applying(transform)
            guard let cropped = image?.crop(rect: rect) else { return [] }
            return manager.requestTextRecognition(image: cropped)
        }
        if let a = recognized.last?.first?.contains("kakao") {
            // 유효기간 -3
            let date = recognized[recognized.index(recognized.endIndex, offsetBy: -4)]
            let brand = recognized[recognized.index(recognized.endIndex, offsetBy: -6)]
            let barcode = recognized[recognized.index(recognized.endIndex, offsetBy: -8)]
            let name = recognized[recognized.index(recognized.endIndex, offsetBy: -9)]

            let response = CouponScan.ScanPhoto.Response(name: name[0], brand: brand[0], barcode: barcode[0], expiredDate: date[0])
            presenter?.presentScanResult(response: response)
        }
    }

    func imageHandler(image: UIImage, pay: OCRManager.Payload) {
        print(pay)
    }
}
