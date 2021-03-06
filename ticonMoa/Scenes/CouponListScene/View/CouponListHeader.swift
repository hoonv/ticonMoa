//
//  CouponListHeader.swift
//  ticonMoa
//
//  Created by 채훈기 on 2021/07/08.
//  Copyright © 2021 hoon. All rights reserved.
//

import UIKit

class CouponListHeader: UIView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }
    
    func setupUI() {
        [addIcon, filterIcon, bellIcon].forEach {
            iconStackView.addArrangedSubview($0)
        }
        
        [separator, iconStackView].forEach {
            addSubview($0)
        }
        
        filterIcon.snp.makeConstraints { make in
            make.width.equalTo(filterIcon.snp.height)
        }
        
        bellIcon.snp.makeConstraints { make in
            make.width.equalTo(bellIcon.snp.height)
        }

        iconStackView.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-12)
            make.bottom.equalTo(separator)
            make.top.equalToSuperview()
            make.width.greaterThanOrEqualTo(60)
        }
        
        separator.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalToSuperview()
            make.height.equalTo(0.8)
        }
    }
    
    let iconStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.distribution = .fillEqually
        return stack
    }()
    
    let separator: UIView = {
        let view = UIView()
        view.backgroundColor = .systemGray5
        return view
    }()
    
    let filterIcon: IconButton = {
        let button = IconButton(systemName: "slider.horizontal.3")
        return button
    }()
    
    let bellIcon: IconButton = {
        let button = IconButton(systemName: "bell")
        return button
    }()

    let addIcon: IconButton = {
        let button = IconButton(systemName: "plus.app", size: 23)
        return button
    }()
}
