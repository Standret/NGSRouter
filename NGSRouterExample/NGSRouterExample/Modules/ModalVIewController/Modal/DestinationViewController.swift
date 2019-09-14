//
//  ModalViewController.swift
//  NGSRouterExample
//
//  Created by Peter Standret on 8/18/19.
//  Copyright © 2019 NGS. All rights reserved.
//

import UIKit
import NGSRouter

class DestinationViewController: UIViewController, DestinationViewDelegate, NGSConfiguratable {
    
    var presenter: DestinationPresenter!
    
    @IBOutlet weak var tfText: UITextField!
    @IBAction func onClose(_ sender: UIButton) {
        presenter.textForClose = tfText.text ?? ""
        presenter.close()
    }
    
    func configure(target: DestinationPresenter) {
        presenter = target
    }
    
    func setValue(parameter: String) {
       // tfText.text = parameter
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()

        tfText.text = presenter.parameter
        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
