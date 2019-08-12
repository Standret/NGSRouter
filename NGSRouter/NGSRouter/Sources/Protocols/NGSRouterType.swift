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
    /// - Parameter parameter: The object which pass to destination VC
    ///
    func loadStoryboard<Navigatable: NGSParamNavigatable>(
        storyboard: NGSStoryboard,
        to _: Navigatable.Type,
        parameter: Navigatable.Parameter
        ) throws
    
    ///
    /// Load new storyboard and made init VC as root
    /// - Parameter storyboard: The target storyboard
    ///
    func loadStoryboard(storyboard: NGSStoryboard) throws
    
    // MARK: - NAVIGATION
    
    ///
    /// Load new module to screen based on generic navigation type
    /// - Parameter to: represent target Navigatable
    /// - Parameter typeNavigation: naviagtion style
    /// - Parameter animated: animated of transition
    ///
    /// - Important: you have to register module for navigation before usage
    ///
    func navigate<Navigatable: NGSNavigatable>(
        to _: Navigatable.Type,
        typeNavigation: NGSTransitionStyle,
        animated: Bool
        ) throws
    
    ///
    /// Load new module to screen based on generic navigation type
    /// - Parameter to: represent target Navigatable
    /// - Parameter parameter: navigation parameter which pass to next module
    /// - Parameter typeNavigation: naviagtion style
    /// - Parameter animated: animated of transition
    ///
    /// - Important: you have to register module for navigation before usage
    ///
    func navigate<Navigatable: NGSParamNavigatable>(
        to _: Navigatable.Type,
        parameter: Navigatable.Parameter,
        typeNavigation: NGSTransitionStyle,
        animated: Bool
        ) throws
    
    ///
    /// Load new module to screen based on generic navigation type with close closure
    /// - Parameter to: represent target Navigatable
    /// - Parameter typeNavigation: naviagtion style
    /// - Parameter animated: animated of transition
    /// - Parameter closeCompletion: represent closure which invokes before close opened module
    ///
    /// - Important: you have to register module for navigation before usage
    ///
    func navigate<Navigatable: NGSCloseNavigatable>(
        to _: Navigatable.Type,
        typeNavigation: NGSTransitionStyle,
        animated: Bool,
        closeCompletion: @escaping CloseCompletition<Navigatable.CloseObject>
        ) throws
    
    ///
    /// Load new module to screen based on generic navigation type with close closure
    /// - Parameter to: represent target Navigatable
    /// - Parameter parameter: navigation parameter which pass to next module
    /// - Parameter typeNavigation: naviagtion style
    /// - Parameter animated: animated of transition
    /// - Parameter closeCompletion: represent closure which invokes before close opened module
    ///
    /// - Important: you have to register module for navigation before usage
    ///
    func navigate<Navigatable: NGSParamCloseNavigatable>(
        to _: Navigatable.Type,
        parameter: Navigatable.Parameter,
        typeNavigation: NGSTransitionStyle,
        animated: Bool,
        closeCompletion: @escaping CloseCompletition<Navigatable.CloseObject>
        ) throws
    
    // MARK: - CLOSE
    
    ///
    /// Close current module
    /// - Parameter animated: animated of transition
    ///
    func close(animated: Bool) throws
    
    ///
    /// Close current module and pass parameter back to calling module
    /// - Parameter target: represent current module
    /// - Parameter parameter: close parameter which pass to calling module
    /// - Parameter animated: animated of transition
    ///
    func close<Navigatable: NGSCloseNavigatable>(
        target: Navigatable,
        parameter: Navigatable.CloseObject,
        animated: Bool
        ) throws
}
