//
//  SearchResultViewController.swift
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

protocol SearchResultDisplayLogic: class {
    func displaySearchedCoupon(viewModel: SearchResult.SearchCoupon.ViewModel)
}

class SearchResultViewController: UIViewController, SearchResultDisplayLogic {
    var interactor: SearchResultBusinessLogic?
    var router: (NSObjectProtocol & SearchResultRoutingLogic & SearchResultDataPassing)?
    
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
        let interactor = SearchResultInteractor()
        let presenter = SearchResultPresenter()
        let router = SearchResultRouter()
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
        self.view.backgroundColor = .systemBackground
        setupUI()
        fetchCoupons()
    }
    
    // MARK: Do something
    
    //@IBOutlet weak var nameTextField: UITextField!
    var coupons: [ViewModelCoupon] = []
    
    func fetchCoupons() {
        guard let keyword = router?.dataStore?.keyword else { return }
        let request = SearchResult.SearchCoupon.Request(keyword: keyword)
        interactor?.fetchSearchCoupon(request: request)
    }
    
    func displaySearchedCoupon(viewModel: SearchResult.SearchCoupon.ViewModel) {
        self.coupons = viewModel.coupons
        self.collectionView.reloadData()
    }
    
    let header: SearchResultHeader = {
        let view = SearchResultHeader()
        return view
    }()
    
    let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let view = UICollectionView(frame: .zero, collectionViewLayout: layout)
        view.backgroundColor = .systemBackground
        view.alwaysBounceVertical = true
        return view
    }()
}

extension SearchResultViewController {
    
    @objc func backTouchOn() {
        self.header.searchBar.resignFirstResponder()
        self.navigationController?.popViewController(animated: true)
    }
    
    func setupUI() {
        self.header.backButton.addTarget(self, action: #selector(backTouchOn), for: .touchUpInside)
        self.header.searchBar.delegate = self
        self.header.searchBar.text = router?.dataStore?.keyword
        self.view.backgroundColor = .systemBackground
        setupCollectionView()
        [header, collectionView].forEach {
            view.addSubview($0)
        }
        
        collectionView.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalToSuperview()
            make.top.equalTo(header.snp.bottom)
        }
        
        header.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.height.equalTo(43)
            make.leading.trailing.equalToSuperview()
        }
        
    }
}

extension SearchResultViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    var cellId: String { return "CouponListCell" }
    
    func setupCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(CouponListCell.self, forCellWithReuseIdentifier: cellId)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return coupons.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as? CouponListCell else { return CouponListCell() }
        cell.configure(viewModel: coupons[indexPath.row])
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let data = coupons[indexPath.row]
        router?.routeToCouponDetail(image: data.image,barcode: data.barcode, id: data.id)    }
}

extension SearchResultViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width - 20, height: 150)
    }
}

extension SearchResultViewController: UISearchBarDelegate {
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = true
        UIView.animate(withDuration: 0.18) {
            self.view.layoutIfNeeded()
        }
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = false
        UIView.animate(withDuration: 0.18) {
            self.view.layoutIfNeeded()
        }
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let keyword = searchBar.text else { return }
        let request = SearchResult.SearchCoupon.Request(keyword: keyword)
        interactor?.fetchSearchCoupon(request: request)
        searchBar.resignFirstResponder()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
        searchBar.resignFirstResponder()
    }
}
