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
    
    case custom(TransitionStyle)
}

public extension NGSTransitionStyle {
    
    var transtionStyle: TransitionStyle {
        switch self {
        case .push:
            return .navigation(style: .push)
        case .modal:
            return .modal(transition: .coverVertical, presentation: .overFullScreen)
        case .crossDisolve:
            return .modal(transition: .crossDissolve, presentation: .overFullScreen)
        case .custom(let style):
            return style
        }
    }
}

fileprivate extension TransitionNode {
    
    func applyConfigurator<Navigatable: NGSNavigatable>(navigatable _: Navigatable.Type) throws -> TransitionNode {
        return try self.apply(to: { destination in
            if let configurator = NGSRouterAssember.shared.fetchConfigurator(navigatable: Navigatable.self) {
                configurator(destination)
            }
        })
    }
}

open class NGSRouter: NGSRouterType {
    
    private(set) public var transitionHandler: TransitionHandler
    
    private var selectorName: String { return NGSRouterConfig.shared.destinationSourceProperyName }
    
    public init(transitionHandler: TransitionHandler) {
        self.transitionHandler = transitionHandler
    }
    
    // MARK: - STORYBOARD LOADING
    
    open func loadStoryboard<Destination: NGSParamNavigatable>(
        storyboard: NGSStoryboard,
        to _: Destination.Type,
        parameter: Destination.Parameter
        ) throws {
        
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
    
    open func loadStoryboard<Destination: NGSNavigatable>(
        to _: Destination.Type,
        storyboard: NGSStoryboard
        ) throws {
        
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
    
    // MARK: - NAVIGATE
    
    open func navigate<Destination: NGSNavigatable>(
        to _: Destination.Type,
        typeNavigation: NGSTransitionStyle,
        animated: Bool
        ) throws {
        
        try getTransitionNode(destination: Destination.self)
            .applyConfigurator(navigatable: Destination.self)
            .selector(selectorName)
            .to(preferred: typeNavigation.transtionStyle)
            .transition(animate: animated)
            .then({ $0.prepare() })
    }
    
    open func navigate<Destination: NGSParamNavigatable>(
        to _: Destination.Type,
        parameter: Destination.Parameter,
        typeNavigation: NGSTransitionStyle,
        animated: Bool
        ) throws {
        
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
    
    public func navigate<Destination: NGSCloseNavigatable>(
        to _: Destination.Type,
        typeNavigation: NGSTransitionStyle,
        animated: Bool,
        closeCompletion: @escaping CloseCompletition<Destination.CloseObject>
        ) throws {
        
        try getTransitionNode(destination: Destination.self)
            .applyConfigurator(navigatable: Destination.self)
            .selector(selectorName)
            .to(preferred: typeNavigation.transtionStyle)
            .transition(animate: animated)
            .then({
                $0.closableObject = closeCompletion
                $0.prepare()
                return ()
            })
    }
    
    public func navigate<Destination: NGSParamCloseNavigatable>(
        to _: Destination.Type,
        parameter: Destination.Parameter,
        typeNavigation: NGSTransitionStyle,
        animated: Bool,
        closeCompletion: @escaping CloseCompletition<Destination.CloseObject>
        ) throws {

        try getTransitionNode(destination: Destination.self)
            .applyConfigurator(navigatable: Destination.self)
            .selector(selectorName)
            .to(preferred: typeNavigation.transtionStyle)
            .transition(animate: animated)
            .then({
                $0.closableObject = closeCompletion
                $0.prepare()
                $0.prepare(parameter: parameter)
            })
    }
    
    // MARK: - CLOSE
    
    open func close(animated: Bool) throws {
        try transitionHandler
            .closeCurrentModule()
            .transition(animate: animated)
            .perform()
    }
    
    open func close<Destination: NGSCloseNavigatable>(
        target: Destination,
        parameter: Destination.CloseObject,
        animated: Bool
        ) throws {
        
        target.closableObject(parameter)
        
        try transitionHandler
            .closeCurrentModule()
            .transition(animate: animated)
            .perform()
    }
    
    internal func getTarfetStoryboardFactory(storyboard: NGSStoryboard, to name: String) -> StoryboardFactory {
        
        let storyboard = UIStoryboard(name: storyboard.name, bundle: Bundle.main)
        return StoryboardFactory(storyboard: storyboard, restorationId: name)
    }
    
    internal func getTransitionNode<Navigatable: NGSNavigatable>(destination: Navigatable.Type) throws -> TransitionNode<Navigatable> {
        
        if let storyboardData = NGSRouterAssember.shared.fetchStoryboard(navigatable: Navigatable.self) {
            return try transitionHandler
                .forStoryboard(
                    factory: StoryboardFactory(
                        storyboardName: storyboardData.storyboard,
                        bundle: Bundle.main,
                        restorationId: storyboardData.storyboardId
                ), to: Navigatable.self
            )
        }
        else if let vcFactory = NGSRouterAssember.shared.fetchVCRegistration(navigatable: Navigatable.self) {
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
