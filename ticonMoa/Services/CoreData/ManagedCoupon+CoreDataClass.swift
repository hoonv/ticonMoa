//
//  ManagedCoupon+CoreDataClass.swift
//  ticonMoa
//
//  Created by 채훈기 on 2021/07/08.
//  Copyright © 2021 hoon. All rights reserved.
//
//

import Foundation
import CoreData

@objc(ManagedCoupon)
public class ManagedCoupon: NSManagedObject {
    
    func configure(id: UUID, name: String, barcode: String, brand: String, expired: Date, category: String, isUsed: Bool, register: Date, image: Data) {
        self.identifier = id
        self.name = name
        self.brand = brand
        self.barcode = barcode
        self.expiredDate = expired
        self.category = category
        self.isUsed = isUsed
        self.registerDate = register
        self.image = image
    }
    
    func configure(coupon: Coupon) {
        self.identifier = coupon.identifier
        self.name = coupon.name
        self.brand = coupon.brand
        self.barcode = coupon.barcode
        self.expiredDate = coupon.expiredDate
        self.category = coupon.category
        self.isUsed = coupon.isUsed
        self.registerDate = coupon.registerDate
        self.image = coupon.image?.pngData() ?? Data()
    }
}
