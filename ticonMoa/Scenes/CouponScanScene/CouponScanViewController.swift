//
//  CouponScanViewController.swift
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

protocol CouponScanDisplayLogic: class {
    func displayScanResult(viewModel: CouponScan.PhotoScan.ViewModel)
}

class CouponScanViewController: UIViewController, CouponScanDisplayLogic {
    var interactor: CouponScanBusinessLogic?
    var router: (NSObjectProtocol & CouponScanRoutingLogic & CouponScanDataPassing)?
    
    // MARK: Object lifecycle
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    // MARK: Setup
    
    private func setup() {
        let viewController = self
        let interactor = CouponScanInteractor()
        let presenter = CouponScanPresenter()
        let router = CouponScanRouter()
        viewController.interactor = interactor
        viewController.router = router
        interactor.presenter = presenter
        presenter.viewController = viewController
        router.viewController = viewController
        router.dataStore = interactor
    }
    
    // MARK: Routing
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let scene = segue.identifier {
            let selector = NSSelectorFromString("routeTo\(scene)WithSegue:")
            if let router = router, router.responds(to: selector) {
                router.perform(selector, with: segue)
            }
        }
    }
    
    // MARK: View lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        scanImageOCR()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    // MARK: Do something
    
    //@IBOutlet weak var nameTextField: UITextField!
    
    func scanImageOCR() {
        let request = CouponScan.PhotoScan.Request()
        interactor?.scanPhoto(request: request)
    }
    
    func displayScanResult(viewModel: CouponScan.PhotoScan.ViewModel) {
        for box in viewModel.boxes {
            let view = UIView(frame: box)
            view.backgroundColor = .clear
            view.layer.borderWidth = 1
            view.layer.borderColor = UIColor.red.cgColor
            imageView.addSubview(view)
            print(box)
        }
    }
    
    // MARK: View
    
    let header: CouponAddHeader = {
        let header = CouponAddHeader()
        return header
    }()
    
    let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = 10
        imageView.clipsToBounds = true
        imageView.backgroundColor = .systemGray
        return imageView
    }()
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.text = "이름"
        label.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
        return label
    }()
    
    let nameInput: UITextField = {
        let input = UITextField()
        input.placeholder = "이름 입력하세요"
        
        input.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        return input
    }()
    
    let brandLabel: UILabel = {
        let label = UILabel()
        label.text = "브랜드"
        label.font = UIFont.systemFont(ofSize: 14, weight: .semibold)

        return label
    }()
    
    let brandInput: UITextField = {
        let input = UITextField()
        input.placeholder = "브랜드를 입력하세요"
        input.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        return input
    }()
    
    let expiredLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: .semibold)

        label.text = "유효기간"
        return label
    }()
    
    let expiredInput: UITextField = {
        let input = UITextField()
        input.placeholder = "유효기간을 입력하세요"
        input.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        return input
    }()
    
    let barcodeLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
        label.text = "바코드"
        return label
    }()
    
    let barcodeInput: UITextField = {
        let input = UITextField()
        input.placeholder = "바코드를 입력하세요"
        input.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        return input
    }()
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
}

extension CouponScanViewController {
    
    func setupUI() {
        guard let image = router?.dataStore?.image else { return }
        let ratio = image.size.height / image.size.width
        nameInput.delegate = self
        brandInput.delegate = self

        self.view.backgroundColor = .systemBackground
        imageView.image = image
        
        [imageView, nameLabel, nameInput, brandLabel, brandInput, header, expiredLabel, expiredInput, barcodeLabel, barcodeInput].forEach {
            view.addSubview($0)
        }
        
        nameLabel.snp.makeConstraints { make in
            make.top.equalTo(imageView.snp.bottom).offset(20)
            make.leading.equalToSuperview().offset(10)
        }
        
        nameInput.snp.makeConstraints { make in
            make.top.equalTo(nameLabel.snp.bottom)
            make.leading.equalToSuperview().offset(10)
            make.trailing.equalToSuperview().offset(-10)
        }
        
        brandLabel.snp.makeConstraints { make in
            make.top.equalTo(nameInput.snp.bottom).offset(30)
            make.leading.equalToSuperview().offset(10)
        }
        
        brandInput.snp.makeConstraints { make in
            make.top.equalTo(brandLabel.snp.bottom)
            make.leading.equalToSuperview().offset(10)
            make.trailing.equalToSuperview().offset(-10)
        }
        
        expiredLabel.snp.makeConstraints { make in
            make.top.equalTo(brandInput.snp.bottom).offset(30)
            make.leading.equalToSuperview().offset(10)
        }
        
        expiredInput.snp.makeConstraints { make in
            make.top.equalTo(expiredLabel.snp.bottom)
            make.leading.equalToSuperview().offset(10)
            make.trailing.equalToSuperview().offset(-10)
        }
        
        barcodeLabel.snp.makeConstraints { make in
            make.top.equalTo(expiredInput.snp.bottom).offset(30)
            make.leading.equalToSuperview().offset(10)
        }
        
        barcodeInput.snp.makeConstraints { make in
            make.top.equalTo(barcodeLabel.snp.bottom)
            make.leading.equalToSuperview().offset(10)
            make.trailing.equalToSuperview().offset(-10)
        }
        
        imageView.snp.makeConstraints { make in
            make.top.equalTo(header.snp.bottom).offset(10)
            make.centerX.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.5)
            make.height.equalTo(imageView.snp.width).multipliedBy(ratio)
        }
        
        header.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.height.equalTo(43)
            make.leading.trailing.equalToSuperview()
        }
        
    }
}

extension CouponScanViewController: UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == nameInput {
            print("nameinput touched")
        }
        if textField == brandInput {
            guard let image = router?.dataStore?.image else { return }
            let ratio = image.size.height / image.size.width
            imageView.removeConstraints(imageView.constraints)
            NSLayoutConstraint.activate([
                imageView.topAnchor.constraint(equalTo: header.bottomAnchor, constant: -50),
                imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                imageView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.5),
                imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor, multiplier: ratio)
            ])
            UIView.animate(withDuration: 0.3) {
                self.view.layoutIfNeeded()
            }
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
    }
}