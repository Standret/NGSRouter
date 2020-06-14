//
//  NGSRouterConfig.swift
//  NGSRouter
//
//  Created by Peter Standret on 8/8/19.
//  Copyright © 2019 - 2020 Peter Standret. All rights reserved.
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.
//

import Foundation
import UIKit

final public class NGSRouterConfig {
    
    public typealias ErrorHandler = (Error) -> Void
    
    private init() { }
    
    public static var shared = NGSRouterConfig()
    
    ///
    /// Represent registered class which return storyboardId for passed object
    /// By default is used Presenter based startegy
    ///
    /// Example:
    ///
    /// TargetNavigatable: class FirstFooPresenter
    /// StoryboardId should be: FirstFoo
    ///
    private(set) public var storyboardIdFactory: NGSStoryboardIdFactory = NGSPresenterStoryboardIdFactory()
    
    ///
    /// This property represent name of property in destination VC.
    /// Property in destination VC is responsibled for storying source VC.
    /// In tradional MVP property store presenter.
    ///
    public var destinationSourceProperyName: String = "presenter"
    
    ///
    /// Determine custom appstart for application
    ///
    public var appStart: NGSAppStart?
    
    ///
    /// This function register new Startegy to get id for storyboard instantinate
    ///
    public func registerStoryboardIdFactory(factory: NGSStoryboardIdFactory) {
        storyboardIdFactory = factory
    }
    
    ///
    /// Handling error during navigation, by default setted print to console
    ///
    public var errorHandler: ErrorHandler? = { error in
        
        if let error = error as? LightRouteError {
            switch error {
            case .viewControllerWasNil(let message):
                NSLog("[NGSRouter] error during navigation: \(message)")
            default:
                NSLog("[NGSRouter] catched unexcpected error during naviation: -- \(error)")
                assertionFailure("catched unexcpected error during naviation: -- \(error)")
            }
        }
        else {
            NSLog("[NGSRouter] catched unexcpected error during naviation: -- \(error)")
            assertionFailure("catched unexcpected error during naviation: -- \(error)")
        }
    }
    
    ///
    /// Function init start view controller and prepare routing
    ///
    public func start(appDelegate: UIApplicationDelegate) {
        assert(appStart != nil, "appStart should be set")
        assert(appDelegate.window != nil && appDelegate.window! != nil, "Window has to be created before calling this method")
        appDelegate.window!!.rootViewController = appStart!.startViewController
        appDelegate.window!!.makeKeyAndVisible()
        
    }
}
