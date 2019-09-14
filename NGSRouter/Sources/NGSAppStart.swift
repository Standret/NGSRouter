//
//  NGSAppStart.swift
//  NGSRouter
//
//  Created by Peter Standret on 9/14/19.
//  Copyright © 2019 NGS. All rights reserved.
//

import Foundation
import UIKit

///
/// The protocol used to determine start viewController
///
public protocol NGSAppStart {
    
    var startViewController: UIViewController { get }
}
