//
//  NGSRouterType.swift
//  NGSRouter
//
//  Created by Peter Standret on 8/8/19.
//  Copyright © 2019 Piter Standret. All rights reserved.
//

import Foundation

public protocol NGSRouterType: class {
    
    ///
    /// Represent abstract type which used for close closure
    ///
    typealias CloseCompletition<Parameter> = (Parameter) -> Void
    
    // MARK: - STORYBOARD LOADING
    
    ///
    /// Load new storyboard and made init VC as root
    /// - Parameter storyboard: The target storyboard
    /// - Parameter to: Metatype of destination source
    ///
    func loadStoryboard<Destination: NGSNavigatable>(
        to _: Destination.Type,
        storyboard: NGSStoryboard
        )
    
    ///
    /// Load new storyboard and made init VC as root
    /// - Parameter storyboard: The target storyboard
    /// - Parameter to: Metatype of destination source
    /// - Parameter parameter: The object which pass to destination VC
    ///
    func loadStoryboard<Destination: NGSParamNavigatable>(
        storyboard: NGSStoryboard,
        to _: Destination.Type,
        parameter: Destination.Parameter
        )
    
    // MARK: - NAVIGATION
    
    ///
    /// Load new module to screen based on generic navigation type
    /// - Parameter to: represent target Destination
    /// - Parameter typeNavigation: naviagtion style
    /// - Parameter animated: animated of transition
    ///
    /// - Important: you have to register module for navigation before usage
    ///
    func navigate<Destination: NGSNavigatable>(
        to _: Destination.Type,
        typeNavigation: NGSTransitionStyle,
        animated: Bool
        )
    
    ///
    /// Load new module to screen based on generic navigation type
    /// - Parameter to: represent target Destination
    /// - Parameter parameter: navigation parameter which pass to next module
    /// - Parameter typeNavigation: naviagtion style
    /// - Parameter animated: animated of transition
    ///
    /// - Important: you have to register module for navigation before usage
    ///
    func navigate<Destination: NGSParamNavigatable>(
        to _: Destination.Type,
        parameter: Destination.Parameter,
        typeNavigation: NGSTransitionStyle,
        animated: Bool
        )
    
    ///
    /// Load new module to screen based on generic navigation type with close closure
    /// - Parameter to: represent target Destination
    /// - Parameter typeNavigation: naviagtion style
    /// - Parameter animated: animated of transition
    /// - Parameter closeCompletion: represent closure which invokes before close opened module
    ///
    /// - Important: you have to register module for navigation before usage
    ///
    func navigate<Destination: NGSCloseNavigatable>(
        to _: Destination.Type,
        typeNavigation: NGSTransitionStyle,
        animated: Bool,
        closeCompletion: @escaping CloseCompletition<Destination.CloseObject>
        )
    
    ///
    /// Load new module to screen based on generic navigation type with close closure
    /// - Parameter to: represent target Destination
    /// - Parameter parameter: navigation parameter which pass to next module
    /// - Parameter typeNavigation: naviagtion style
    /// - Parameter animated: animated of transition
    /// - Parameter closeCompletion: represent closure which invokes before close opened module
    ///
    /// - Important: you have to register module for navigation before usage
    ///
    func navigate<Destination: NGSParamCloseNavigatable>(
        to _: Destination.Type,
        parameter: Destination.Parameter,
        typeNavigation: NGSTransitionStyle,
        animated: Bool,
        closeCompletion: @escaping CloseCompletition<Destination.CloseObject>
        )
    
    // MARK: - CLOSE
    
    ///
    /// Close current module
    /// - Parameter animated: animated of transition
    ///
    func close(animated: Bool)
    
    ///
    /// Close current module and pass parameter back to calling module
    /// - Parameter target: represent current module
    /// - Parameter parameter: close parameter which pass to calling module
    /// - Parameter animated: animated of transition
    ///
    func close<Destination: NGSCloseNavigatable>(
        target: Destination,
        parameter: Destination.CloseObject,
        animated: Bool
        )
}

extension NGSRouterType {
    
    ///
    /// Load new module to screen based on generic navigation type
    /// - Parameter to: represent target Destination
    /// - Parameter typeNavigation: naviagtion style
    /// - Parameter animated: animated of transition
    ///
    /// - Important: you have to register module for navigation before usage
    ///
    func navigate<Destination: NGSNavigatable>(
        to _: Destination.Type,
        typeNavigation: NGSTransitionStyle = .push,
        animated: Bool = true
        ) {
        
        self.navigate(
            to: Destination.self,
            typeNavigation: typeNavigation,
            animated: animated
        )
    }
    
    ///
    /// Load new module to screen based on generic navigation type
    /// - Parameter to: represent target Destination
    /// - Parameter parameter: navigation parameter which pass to next module
    /// - Parameter typeNavigation: naviagtion style
    /// - Parameter animated: animated of transition
    ///
    /// - Important: you have to register module for navigation before usage
    ///
    func navigate<Destination: NGSParamNavigatable>(
        to _: Destination.Type,
        parameter: Destination.Parameter,
        typeNavigation: NGSTransitionStyle = .push,
        animated: Bool = true
        ) {
        
        self.navigate(
            to: Destination.self,
            parameter: parameter,
            typeNavigation: typeNavigation,
            animated: animated
        )
    }
    
    ///
    /// Load new module to screen based on generic navigation type with close closure
    /// - Parameter to: represent target Destination
    /// - Parameter typeNavigation: naviagtion style
    /// - Parameter animated: animated of transition
    /// - Parameter closeCompletion: represent closure which invokes before close opened module
    ///
    /// - Important: you have to register module for navigation before usage
    ///
    func navigate<Destination: NGSCloseNavigatable>(
        to _: Destination.Type,
        typeNavigation: NGSTransitionStyle = .push,
        animated: Bool = true,
        closeCompletion: @escaping CloseCompletition<Destination.CloseObject>
        ) {
        
        self.navigate(
            to: Destination.self,
            typeNavigation: typeNavigation,
            animated: animated,
            closeCompletion: closeCompletion
        )
    }
    
    ///
    /// Load new module to screen based on generic navigation type with close closure
    /// - Parameter to: represent target Destination
    /// - Parameter parameter: navigation parameter which pass to next module
    /// - Parameter typeNavigation: naviagtion style
    /// - Parameter animated: animated of transition
    /// - Parameter closeCompletion: represent closure which invokes before close opened module
    ///
    /// - Important: you have to register module for navigation before usage
    ///
    func navigate<Destination: NGSParamCloseNavigatable>(
        to _: Destination.Type,
        parameter: Destination.Parameter,
        typeNavigation: NGSTransitionStyle = .push,
        animated: Bool = true,
        closeCompletion: @escaping CloseCompletition<Destination.CloseObject>
        ) {
        
        self.navigate(
            to: Destination.self,
            parameter: parameter,
            typeNavigation: typeNavigation,
            animated: animated,
            closeCompletion: closeCompletion
        )
    }
    
    // MARK: - CLOSE
    
    ///
    /// Close current module
    /// - Parameter animated: animated of transition
    ///
    func close(animated: Bool = true) {
        self.close(animated: animated)
    }
    
    ///
    /// Close current module and pass parameter back to calling module
    /// - Parameter target: represent current module
    /// - Parameter parameter: close parameter which pass to calling module
    /// - Parameter animated: animated of transition
    ///
    func close<Destination: NGSCloseNavigatable>(
        target: Destination,
        parameter: Destination.CloseObject,
        animated: Bool = true
        ) {
        
        self.close(
            target: target,
            parameter: parameter,
            animated: animated
        )
    }
}
