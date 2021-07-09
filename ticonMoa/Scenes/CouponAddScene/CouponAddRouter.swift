//
//  CouponAddRouter.swift
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

@objc protocol CouponAddRoutingLogic {
    func routeToCouponScan(index: IndexPath)
}

protocol CouponAddDataPassing {
    var dataStore: CouponAddDataStore? { get }
}

class CouponAddRouter: NSObject, CouponAddRoutingLogic, CouponAddDataPassing {
    weak var viewController: CouponAddViewController?
    var dataStore: CouponAddDataStore?
    
    // MARK: Routing
    
    func routeToCouponScan(index: IndexPath) {
        let controller = CouponScanViewController()
        guard
            let sourceDataStore = dataStore,
            var destDataStore = controller.router?.dataStore else { return }
        passDataToSomewhere(source: sourceDataStore, destination: &destDataStore, index: index)
        viewController?.navigationController?.pushViewController(controller, animated: true)
    }
    
    // MARK: Passing data
    
    func passDataToSomewhere(source: CouponAddDataStore, destination: inout CouponScanDataStore, index: IndexPath) {
        destination.image = source.images[index.row]
    }
}
