//
//  NGSRouterConfig.swift
//  NGSRouter
//
//  Created by Peter Standret on 8/8/19.
//  Copyright © 2019 Piter Standret. All rights reserved.
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
        appDelegate.window!!.rootViewController = appStart!.startViewController
        appDelegate.window!!.makeKeyAndVisible()
        
    }
}
