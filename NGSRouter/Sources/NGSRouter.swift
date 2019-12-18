//
//  NGSRouter.swift
//  NGSRouter
//
//  Created by Peter Standret on 8/8/19.
//  Copyright © 2019 Piter Standret. All rights reserved.
//

import Foundation
import UIKit

public enum NGSError: Error {
    case notRegistered
    case castError(String)
}

public enum NGSTransitionStyle {
    
    case push
    case modal
    case crossDisolve
    case formSheet
    
    case custom(TransitionStyle)
}

public extension NGSTransitionStyle {
    
    var transtionStyle: TransitionStyle {
        switch self {
        case .push:
            return .navigation(style: .push)
        case .modal:
            return .modal(transition: .coverVertical, presentation: .fullScreen)
        case .crossDisolve:
            return .modal(transition: .crossDissolve, presentation: .fullScreen)
        case .formSheet:
            return .modal(transition: .coverVertical, presentation: .formSheet)
        case .custom(let style):
            return style
        }
    }
}

fileprivate extension TransitionNode {
    
    func applyConfigurator<Navigatable: NGSNavigatable>(navigatable _: Navigatable.Type) throws -> TransitionNode {
        return try self.apply(to: { destination in
            
            var viewController = destination
            if viewController is UINavigationController {
                viewController = (viewController as! UINavigationController).topViewController ?? viewController
            }
            
            if let configurator = NGSRouterAssember.default.fetchConfigurator(Navigatable.self) {
                configurator(viewController)
            }
        })
    }
}

open class NGSRouter: NGSRouterType {
    
    private(set) public unowned var transitionHandler: TransitionHandler
    
    private var selectorName: String { return NGSRouterConfig.shared.destinationSourceProperyName }
    
    public init(transitionHandler: TransitionHandler) {
        self.transitionHandler = transitionHandler
    }
    
    // MARK: - STORYBOARD LOADING
    
    open func loadStoryboard<Destination: NGSParamNavigatable>(
        storyboard: NGSStoryboard,
        to _: Destination.Type,
        parameter: Destination.Parameter
    ) {
        
        executer {
            try transitionHandler
                .forStoryboard(factory: getTarfetStoryboardFactory(storyboard: storyboard, to: ""), to: Destination.self)
                .applyConfigurator(navigatable: Destination.self)
                .selector(selectorName)
                .customTransition()
                .transition({ (_, destination) in
                    UIApplication.shared.keyWindow?.rootViewController = destination
                })
                .then({
                    $0.prepare()
                    $0.prepare(parameter: parameter)
                    return ()
                })
        }
    }
    
    open func loadStoryboard<Destination: NGSNavigatable>(
        to _: Destination.Type,
        storyboard: NGSStoryboard
    ) {
        
        executer {
            try transitionHandler
                .forStoryboard(factory: getTarfetStoryboardFactory(storyboard: storyboard, to: ""), to: NGSNavigatable.self)
                .applyConfigurator(navigatable: Destination.self)
                .selector(selectorName)
                .customTransition()
                .transition({ (_, destination) in
                    UIApplication.shared.keyWindow?.rootViewController = destination
                })
                .then({ $0.prepare() })
        }
    }
    
    // MARK: - NAVIGATE
    
    open func navigate<Destination: NGSNavigatable>(
        to _: Destination.Type,
        typeNavigation: NGSTransitionStyle,
        animated: Bool
    ) {
        
        executer {
            try getTransitionNode(destination: Destination.self)
                .applyConfigurator(navigatable: Destination.self)
                .selector(selectorName)
                .to(preferred: typeNavigation.transtionStyle)
                .transition(animate: animated)
                .then({ $0.prepare() })
        }
    }
    
    open func navigate<Destination: NGSParamNavigatable>(
        to _: Destination.Type,
        parameter: Destination.Parameter,
        typeNavigation: NGSTransitionStyle,
        animated: Bool
    ) {
        
        executer {
            try getTransitionNode(destination: Destination.self)
                .applyConfigurator(navigatable: Destination.self)
                .selector(selectorName)
                .to(preferred: typeNavigation.transtionStyle)
                .transition(animate: animated)
                .then({
                    $0.prepare()
                    $0.prepare(parameter: parameter)
                    return ()
                })
        }
    }
    
    public func navigate<Destination: NGSCloseNavigatable>(
        to _: Destination.Type,
        typeNavigation: NGSTransitionStyle,
        animated: Bool,
        closeCompletion: @escaping CloseCompletition<Destination.CloseObject>
    ) {
        
        executer {
            try getTransitionNode(destination: Destination.self)
                .applyConfigurator(navigatable: Destination.self)
                .selector(selectorName)
                .to(preferred: typeNavigation.transtionStyle)
                .transition(animate: animated)
                .then({
                    $0.closableObject = NGSCloseObject(closeClosure: closeCompletion)
                    $0.prepare()
                    return ()
                })
        }
    }
    
    public func navigate<Destination: NGSParamCloseNavigatable>(
        to _: Destination.Type,
        parameter: Destination.Parameter,
        typeNavigation: NGSTransitionStyle,
        animated: Bool,
        closeCompletion: @escaping CloseCompletition<Destination.CloseObject>
    ) {
        
        executer {
            try getTransitionNode(destination: Destination.self)
                .applyConfigurator(navigatable: Destination.self)
                .selector(selectorName)
                .to(preferred: typeNavigation.transtionStyle)
                .transition(animate: animated)
                .then({
                    $0.closableObject = NGSCloseObject(closeClosure: closeCompletion)
                    $0.prepare()
                    $0.prepare(parameter: parameter)
                })
        }
    }
    
    // MARK: - CLOSE
    
    open func close(animated: Bool) {
        executer {
            try transitionHandler
                .closeCurrentModule()
                .transition(animate: animated)
                .perform()
        }
    }
    
    open func close<Destination: NGSCloseNavigatable>(
        target: Destination,
        parameter: Destination.CloseObject,
        animated: Bool
    ) {
        
        target.closableObject.invoke(with: parameter)
        
        executer {
            try transitionHandler
                .closeCurrentModule()
                .transition(animate: animated)
                .perform()
        }
    }
    
    internal func getTarfetStoryboardFactory(storyboard: NGSStoryboard, to name: String) -> StoryboardFactory {
        
        let storyboard = UIStoryboard(name: storyboard.name, bundle: Bundle.main)
        return StoryboardFactory(storyboard: storyboard, restorationId: name)
    }
    
    internal func getTransitionNode<Navigatable: NGSNavigatable>(destination: Navigatable.Type) throws -> TransitionNode<Navigatable> {
        
        if let storyboardData = NGSRouterAssember.default.fetchStoryboard(Navigatable.self) {
            return try transitionHandler
                .forStoryboard(
                    factory: StoryboardFactory(
                        storyboardName: storyboardData.storyboard,
                        bundle: Bundle.main,
                        restorationId: storyboardData.storyboardId
                    ), to: Navigatable.self
            )
        }
        else if let vcFactory = NGSRouterAssember.default.fetchVCRegistration(Navigatable.self) {
            return TransitionNode(
                root: transitionHandler as! UIViewController,
                destination: vcFactory(),
                for: Navigatable.self
            )
        }
        else {
            throw NGSError.notRegistered
        }
    }
}

public extension NGSRouter {
    
    ///
    /// Instantiate view controller for given key
    ///
    static func instantiate<Destination: NGSNavigatable>(of _: Destination.Type) -> UIViewController {
        
        var result: UIViewController
        var viewController: UIViewController
        
        if let storyboardData = NGSRouterAssember.default.fetchStoryboard(Destination.self) {
            result = UIStoryboard(name: storyboardData.storyboard, bundle: nil)
                .instantiateViewController(withIdentifier: storyboardData.storyboardId)
            
            if result is UINavigationController {
                viewController = (result as! UINavigationController).topViewController ?? result
            }
            else {
                viewController = result
            }
        }
        else if let vcFactory = NGSRouterAssember.default.fetchVCRegistration(Destination.self) {
            result = vcFactory()
            viewController = result
        }
        else {
            fatalError("Target \(type(of: Destination.self)) is not registered")
        }
        
        if let configurator = NGSRouterAssember.default.fetchConfigurator(Destination.self) {
            configurator(viewController)
        }
        
        return result
    }
    
    ///
    /// Instantiate view controller
    ///
    static func instantiateEntryPoint<Destination: NGSNavigatable>(of _: Destination.Type) -> UIViewController {
        
        var result: UIViewController
        var viewController: UIViewController
        
        if let storyboardData = NGSRouterAssember.default.fetchStoryboard(Destination.self) {
            result = UIStoryboard(name: storyboardData.storyboard, bundle: nil)
                .instantiateInitialViewController()!
            
            if result is UINavigationController {
                viewController = (result as! UINavigationController).topViewController ?? result
            }
            else {
                viewController = result
            }
        }
        else if let vcFactory = NGSRouterAssember.default.fetchVCRegistration(Destination.self) {
            result = vcFactory()
            viewController = result
        }
        else {
            fatalError("Target \(type(of: Destination.self)) is not registered")
        }
        
        if let configurator = NGSRouterAssember.default.fetchConfigurator(Destination.self) {
            configurator(viewController)
        }
        
        return result
    }
}

fileprivate extension NGSRouter {
    
    func executer(action: () throws -> Void) {
        
        do {
            try action()
        }
        catch {
            NGSRouterConfig.shared.errorHandler?(error)
        }
    }
}
