//
//  SearchResultRouter.swift
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

@objc protocol SearchResultRoutingLogic {
    //func routeToSomewhere(segue: UIStoryboardSegue?)
}

protocol SearchResultDataPassing {
    var dataStore: SearchResultDataStore? { get }
}

class SearchResultRouter: NSObject, SearchResultRoutingLogic, SearchResultDataPassing {
    weak var viewController: SearchResultViewController?
    var dataStore: SearchResultDataStore?
    
    // MARK: Routing
    
    //func routeToSomewhere(segue: UIStoryboardSegue?)
    //{
    //  if let segue = segue {
    //    let destinationVC = segue.destination as! SomewhereViewController
    //    var destinationDS = destinationVC.router!.dataStore!
    //    passDataToSomewhere(source: dataStore!, destination: &destinationDS)
    //  } else {
    //    let storyboard = UIStoryboard(name: "Main", bundle: nil)
    //    let destinationVC = storyboard.instantiateViewController(withIdentifier: "SomewhereViewController") as! SomewhereViewController
    //    var destinationDS = destinationVC.router!.dataStore!
    //    passDataToSomewhere(source: dataStore!, destination: &destinationDS)
    //    navigateToSomewhere(source: viewController!, destination: destinationVC)
    //  }
    //}
    
    // MARK: Navigation
    
    //func navigateToSomewhere(source: SearchResultViewController, destination: SomewhereViewController)
    //{
    //  source.show(destination, sender: nil)
    //}
    
    // MARK: Passing data
    
    //func passDataToSomewhere(source: SearchResultDataStore, destination: inout SomewhereDataStore)
    //{
    //  destination.name = source.name
    //}
}