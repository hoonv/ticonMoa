//
//  PhotoManager.swift
//  ticonMoa
//
//  Created by 채훈기 on 2021/03/25.
//

import UIKit
import Photos
import RxSwift

final class PhotoManager {

    typealias Completion = ([PHAsset]) -> ()

    let imageOutput = PublishSubject<UIImage>()
    let isProccess = PublishSubject<Bool>()
    private let bag = DisposeBag()
    private var completionHandler: Completion?
    
    init (completionHandler: Completion?) {
        self.completionHandler = completionHandler
    }
    
    func requestAuthorization() {
        if #available(iOS 14, *) {
            PHPhotoLibrary.requestAuthorization(for: .readWrite, handler: requestAuthHandler)
        } else {
            PHPhotoLibrary.requestAuthorization(requestAuthHandler)
        }
    }
    
    private func requestAuthHandler(status: PHAuthorizationStatus) {
        switch status {
        case .denied, .notDetermined, .restricted:
            print("사진 권한이 필요합니다")
        case .limited, .authorized:
            requestPhotos()
        @unknown default:
            break
        }
    }
    
    // PhotoLibray에 요청하는 옵션
    private var fetchOptions: PHFetchOptions = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        let options = PHFetchOptions()
        options.sortDescriptors = [NSSortDescriptor(key:"creationDate", ascending: false)]
//        options.fetchLimit = 1000
        let end = formatter.string(from: Date(timeIntervalSinceNow: -180*24*60*60))
        let today = formatter.string(from: Date(timeIntervalSinceNow: 24*60*60))
        if let startDate = formatter.date(from: end),
           let endDate = formatter.date(from: today) {
            options.predicate = NSPredicate(format: "creationDate > %@ AND creationDate < %@", startDate as NSDate, endDate as NSDate)
        }
        return options
    }()
    
    // fetchResult -> Image로 변환할때 필요한 옵션
    var requestOptions: PHImageRequestOptions = {
        let option = PHImageRequestOptions()
        option.isSynchronous = false
        option.deliveryMode = .highQualityFormat
        return option
    }()
    var targetSize = CGSize(width: 500, height: 800)
    var contentMode: PHImageContentMode = .aspectFit
     
    func requestPhotos() {
        let fetchResult: PHFetchResult = PHAsset.fetchAssets(with: PHAssetMediaType.image, options: self.fetchOptions)
        let assets = fetchResult.objects(at:
                                IndexSet(integersIn: 0..<fetchResult.count))
        
        let photos: [PHAsset] = PhotoCluster(data: assets).execute()
    
        completionHandler?(photos)
    }
}
