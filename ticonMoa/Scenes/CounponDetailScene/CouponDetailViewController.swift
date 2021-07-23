//
//  CouponDetailViewController.swift
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

protocol CouponDetailDisplayLogic: class {
    func displaySomething(viewModel: CouponDetail.Something.ViewModel)
}

class CouponDetailViewController: UIViewController, CouponDetailDisplayLogic {
    var interactor: CouponDetailBusinessLogic?
    var router: (NSObjectProtocol & CouponDetailRoutingLogic & CouponDetailDataPassing)?
    
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
        let interactor = CouponDetailInteractor()
        let presenter = CouponDetailPresenter()
        let router = CouponDetailRouter()
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
        doSomething()
        setupUI()
    }
    
    // MARK: Do something
    
    //@IBOutlet weak var nameTextField: UITextField!
    
    func doSomething() {
        let request = CouponDetail.Something.Request()
        interactor?.doSomething(request: request)
    }
    
    func displaySomething(viewModel: CouponDetail.Something.ViewModel) {
        //nameTextField.text = viewModel.name
    }

    // MARK: Views
    
    var image: UIImage?
    
    let imageView: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
        return view
    }()
    
    let footer: BottomButtonSet = {
        let view = BottomButtonSet()
        return view
    }()
}

extension CouponDetailViewController {
    
    func setupUI() {
        self.view.backgroundColor = .systemBackground
        self.imageView.image = image

        footer.trashButton.addTarget(self, action: #selector(trashButtonTouched), for: .touchUpInside)
        footer.useItButton.addTarget(self, action: #selector(useItButtonTouched), for: .touchUpInside)
        
        [imageView, footer].forEach { view.addSubview($0) }
        
        imageView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.bottom.equalTo(footer.snp.top).offset(-12)
        }
        
        footer.snp.makeConstraints { make in
            make.bottom.equalTo(view.safeAreaLayoutGuide).offset(-12)
            make.height.equalTo(60)
            make.centerX.equalToSuperview()
        }
    }
    
    @objc func useItButtonTouched() {
        alert(title: "쿠폰사용", message: "쿠폰을 사용하셨습니까?", okTitle: "확인", okHandler: useItOKHandler,
              okStyle: .default, cancelTitle: "취소", cancelHandler: nil, completion: nil)
    }
    
    @objc func trashButtonTouched() {
        alert(title: "쿠폰삭제", message: "쿠폰을 완전히 삭제 하시겠습니까?", okTitle: "삭제", okHandler: trashOKHandler, okStyle: .destructive, cancelTitle: "취소", cancelHandler: nil, completion: nil)
    }
    
    func useItOKHandler(action: UIAlertAction) {
        guard let id = router?.dataStore?.identifier else { return }
        guard let barcode = router?.dataStore?.barcode else { return }
        CoreDataManager.shared.update(id: id, isUsed: true)
        NotificationCenter.default.post(name: .couponListChanged, object: nil)
        self.dismiss(animated: true, completion: nil)
    }

    func trashOKHandler(action: UIAlertAction) {
        guard let barcode = router?.dataStore?.barcode else { return }
        if CoreDataManager.shared.delete(barcode: barcode) {
            NotificationCenter.default.post(name: .couponListChanged, object: nil)
            self.dismiss(animated: true, completion: nil)
        }
    }
}
