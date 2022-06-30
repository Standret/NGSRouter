//
//  ViewController.swift
//  NGSRouterExample
//
//  Created by Peter Standret on 8/12/19.
//  Copyright © 2019 NGS. All rights reserved.
//

import UIKit
import NGSRouter

class ViewController: UIViewController {
    
    private var _router: NGSRouterType!
    
    @IBOutlet weak var swtchtCloseCallback: UISwitch!
    @IBOutlet weak var swtchParameter: UISwitch!
    @IBOutlet weak var swtchAnimated: UISwitch!
    @IBOutlet weak var switchEmbedInNavController: UISwitch!
    
    @IBOutlet weak var tfText: UITextField!
    @IBOutlet weak var lblText: UILabel!
    
    @IBAction func onModalPresentationClicked(_ sender: Any) {
        makeNavigation(with: .modal)
    }
    
    @IBAction func noPushPresentationClicked(_ sender: UIButton) {
        makeNavigation(with: .push)

    }
    @IBAction func onCrossDisolvePresentationClicked(_ sender: Any) {
        makeNavigation(with: .crossDisolve)
    }
    
    @IBAction func onModalPageSheet(_ sender: Any) {
        makeNavigation(with: .pageSheet)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        _router = NGSRouter(transitionHandler: self)
    }
    
    private func makeNavigation(with type: NGSTransitionStyle) {
        let navController: UINavigationController? = self.switchEmbedInNavController.isOn
        ? UINavigationController() : nil
        if swtchParameter.isOn && swtchtCloseCallback.isOn {
            _router.navigate(
                to: DestinationPresenter.self,
                navigationController: navController,
                parameter: tfText.text!,
                typeNavigation: type,
                animated: swtchAnimated.isOn,
                closeCompletion: { self.lblText.text = $0 }
            )
        }
        else if swtchParameter.isOn {
            _router.navigate(
                to: DestinationPresenter.self,
                navigationController: navController,
                parameter: tfText.text!,
                typeNavigation: type,
                animated: swtchAnimated.isOn
            )
        }
        else if swtchtCloseCallback.isOn {
            _router.navigate(
                to: DestinationPresenter.self,
                navigationController: navController,
                typeNavigation: type,
                animated: swtchAnimated.isOn,
                closeCompletion: { self.lblText.text = $0 }
            )
        }
        else {
            _router.navigate(
                to: DestinationPresenter.self,
                navigationController: navController,
                typeNavigation: type,
                animated: swtchAnimated.isOn
            )
        }
    }
}

