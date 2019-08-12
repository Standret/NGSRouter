//
//  NGSRouter.swift
//  NGSRouter
//
//  Created by Peter Standret on 8/8/19.
//  Copyright © 2019 Piter Standret. All rights reserved.
//

import Foundation
import UIKit

class BaseSomePresenter<TParameter>: NGSParamNavigatable {
    
    func prepare() {
        print("11")
    }
    
    
    func prepare(parameter: TParameter) {
        print(parameter)
        
        let router: NGSRouterType = NGSRouter(transitionHandler: UIViewController.init())
        try! router.navigate(
            to: ParticularPresenter.self,
            parameter: 2319,
            typeNavigation: .crossDisolve,
            animated: true,
            closeCompletion: { print("This is \($0 == false)") }
        )
    }
    
    typealias Item = TParameter
}

class ParticularPresenter: NGSParamCloseNavigatable {
    
    var closableObject: (Bool) -> Void = { _ in }
    
    typealias Parameter = Int
    typealias CloseObject = Bool
    
    func prepare() {
        
    }
    
    func prepare(parameter: Int) {
        
    }
    
}

public enum NGSError: Error {
    case notRegistered
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
            return .navigation(style: .present)
        case .crossDisolve:
            return .modal(style: (transition: .crossDissolve, presentation: .overFullScreen))
        case .custom(let style):
            return style
        }
    }
}

open class NGSRouter: NGSRouterType {
    
    private(set) public var transitionHandler: TransitionHandler
    
    private var selectorName: String { return NGSRouterConfig.shared.destinationSourceProperyName }
    
    public init(transitionHandler: TransitionHandler) {
        self.transitionHandler = transitionHandler
    }
    
    // MARK: - STORYBOARD LOADING
    
    open func loadStoryboard<Presenter: NGSParamNavigatable>(
        storyboard: NGSStoryboard,
        to _: Presenter.Type,
        parameter: Presenter.Parameter) throws {
        
        try transitionHandler
            .forStoryboard(factory: getTarfetStoryboardFactory(storyboard: storyboard, to: ""), to: Presenter.self)
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
    
    open func loadStoryboard(storyboard: NGSStoryboard) throws {
        
        try transitionHandler
            .forStoryboard(factory: getTarfetStoryboardFactory(storyboard: storyboard, to: ""), to: NGSNavigatable.self)
            .selector(selectorName)
            .customTransition()
            .transition({ (_, destination) in
                UIApplication.shared.keyWindow?.rootViewController = destination
            })
            .then({ $0.prepare() })
    }
    
    // MARK: - NAVIGATE
    
    open func navigate<Presenter: NGSNavigatable>(
        to _: Presenter.Type,
        typeNavigation: NGSTransitionStyle,
        animated: Bool) throws {
        
        try getTransitionNode(presenter: Presenter.self)
            .selector(selectorName)
            .to(preferred: typeNavigation.transtionStyle)
            .transition(animate: animated)
            .then({ $0.prepare() })
    }
    
    open func navigate<Presenter: NGSParamNavigatable>(
        to _: Presenter.Type,
        parameter: Presenter.Parameter,
        typeNavigation: NGSTransitionStyle,
        animated: Bool) throws {
        
        try getTransitionNode(presenter: Presenter.self)
            .selector(selectorName)
            .to(preferred: typeNavigation.transtionStyle)
            .transition(animate: animated)
            .then({
                $0.prepare()
                $0.prepare(parameter: parameter)
                return ()
            })
    }
    
    public func navigate<Presenter: NGSCloseNavigatable>(
        to _: Presenter.Type,
        typeNavigation: NGSTransitionStyle,
        animated: Bool,
        closeCompletion: @escaping CloseCompletition<Presenter.CloseObject>) throws {
        
        try getTransitionNode(presenter: Presenter.self)
            .selector(selectorName)
            .to(preferred: typeNavigation.transtionStyle)
            .transition(animate: animated)
            .then({
                $0.closableObject = closeCompletion
                $0.prepare()
                return ()
            })
    }
    
    public func navigate<Presenter: NGSParamCloseNavigatable>(
        to _: Presenter.Type,
        parameter: Presenter.Parameter,
        typeNavigation: NGSTransitionStyle,
        animated: Bool,
        closeCompletion: @escaping CloseCompletition<Presenter.CloseObject>) throws {

        try getTransitionNode(presenter: Presenter.self)
            .selector(selectorName)
            .to(preferred: typeNavigation.transtionStyle)
            .transition(animate: animated)
            .then({
                $0.closableObject = closeCompletion
                $0.prepare()
                $0.prepare(parameter: parameter)
                return ()
            })
    }
    
    // MARK: - CLOSE
    
    open func close(animated: Bool) throws {
        try transitionHandler
            .closeCurrentModule()
            .transition(animate: animated)
            .perform()
    }
    
    open func close<Presenter: NGSCloseNavigatable>(
        target: Presenter,
        parameter: Presenter.CloseObject,
        animated: Bool) throws {
        
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
    
    internal func getTransitionNode<Navigatable: NGSNavigatable>(presenter: Navigatable.Type) throws -> TransitionNode<Navigatable> {
        
        if let storyboardData = NGSRouterAssember.shared.fetchStoryboard(navigatable: Navigatable.self) {
            return try transitionHandler
                .forStoryboard(
                    factory: StoryboardFactory(
                        storyboardName: storyboardData.storyboard,
                        bundle: Bundle.main,
                        restorationId: storyboardData.storyboardId
                ), to: Navigatable.self)
        }
        else if let vcFactory = NGSRouterAssember.shared.fetchVCRegistration(navigatable: Navigatable.self) {
            return TransitionNode(root: transitionHandler as! UIViewController, destination: vcFactory(), for: Navigatable.self)
        }
        else {
            throw NGSError.notRegistered
        }
    }
}
