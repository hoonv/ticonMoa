//
//  CouponDetailInteractor.swift
//  ticonMoa
//
//  Created by 채훈기 on 2021/07/21.
//  Copyright (c) 2021 hoon. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit

protocol CouponDetailBusinessLogic {
    func doSomething(request: CouponDetail.Something.Request)
}

protocol CouponDetailDataStore {
    var barcode: String { get set }
    var identifier: UUID { get set }
}

class CouponDetailInteractor: CouponDetailBusinessLogic, CouponDetailDataStore {
    var presenter: CouponDetailPresentationLogic?
    var worker: CouponDetailWorker?
    var barcode: String = ""
    var identifier: UUID = UUID()
    
    // MARK: Do something
    
    func doSomething(request: CouponDetail.Something.Request) {
        worker = CouponDetailWorker()
        worker?.doSomeWork()
        
        let response = CouponDetail.Something.Response()
        presenter?.presentSomething(response: response)
    }
}
