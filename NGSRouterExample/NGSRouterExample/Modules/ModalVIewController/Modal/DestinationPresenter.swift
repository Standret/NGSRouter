//
//  ModalPresenter.swift
//  NGSRouterExample
//
//  Created by Peter Standret on 8/18/19.
//  Copyright © 2019 NGS. All rights reserved.
//

import Foundation
import UIKit
import NGSRouter

protocol Viewable { }
extension UIViewController: Viewable { }

protocol DestinationViewDelegate: Viewable {
    func setValue(parameter: String)
}

class DestinationPresenter: NGSParamCloseNavigatable {
    
    private var _router: NGSRouterType
    
    var delegate: DestinationViewDelegate!
    var closableObject = NGSCloseObject<String>()
    
    var parameter: String = ""
    var textForClose: String = ""
    
    init (view: DestinationViewDelegate, router: NGSRouterType) {
        delegate = view
        _router = router
    }
    
    func prepare() {
        
    }
    
    func prepare(parameter: String) {
        self.parameter = parameter
    }
    
    func close() {
        _router.close(target: self, parameter: textForClose, animated: true)
    }
}
