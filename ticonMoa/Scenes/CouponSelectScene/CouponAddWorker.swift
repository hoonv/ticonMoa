//
//  CouponAddWorker.swift
//  ticonMoa
//
//  Created by 채훈기 on 2021/07/08.
//  Copyright (c) 2021 hoon. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit
import Photos

class CouponAddWorker {
    
    private var requestOptions: PHImageRequestOptions = {
        let option = PHImageRequestOptions()
        option.isSynchronous = false
        option.deliveryMode = .highQualityFormat
        return option
    }()
    private var targetSize = CGSize(width: 300, height: 300)
    private var highTargetSize = CGSize(width: 900, height: 900)

    private var contentMode: PHImageContentMode = .aspectFit
    
    private var images: [UIImage] = []
    private var assets: [PHAsset] = []

    private var completionHandler: (([PHAsset], [UIImage]) -> Void)?
    
    init(completionHandler: (([PHAsset], [UIImage]) -> Void)?) {
        self.completionHandler = completionHandler
    }
    
    func fetchPhotos() {
        PhotoManager(completionHandler: requestImages).requestAuthorization()
    }
    
    private func requestImages(assets: [PHAsset]) {
        for asset in assets {
            PHImageManager.default().requestImage(for: asset, targetSize: self.targetSize, contentMode: self.contentMode, options: self.requestOptions, resultHandler: {image, hash in
                guard let image = image else { return }
                self.images.append(image)
                self.assets.append(asset)
                if self.images.count == assets.count {
                    self.completionHandler?(self.assets, self.images)
                }
            })
        }
    }
    
    func requestImage(asset: PHAsset, completionHandler: @escaping (UIImage) -> Void) {
        PHImageManager.default().requestImage(for: asset, targetSize: self.highTargetSize, contentMode: self.contentMode, options: self.requestOptions, resultHandler: {image, hash in
            guard let image = image else { return }
            completionHandler(image)
        })
    }
}