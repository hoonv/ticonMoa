//
//  SearchResultModels.swift
//  ticonMoa
//
//  Created by 채훈기 on 2021/07/27.
//  Copyright (c) 2021 hoon. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit

enum SearchResult {
    // MARK: Use cases
    
    enum SearchCoupon {
        struct Request {
            let keyword: String
        }
        
        struct Response {
            let coupons: [Coupon]
        }
        
        struct ViewModel {
            let coupons: [ViewModelCoupon]
        }
    }
}
