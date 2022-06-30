//
//  NGSRouterType.swift
//  NGSRouter
//
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

public protocol NGSRouterType: AnyObject {
    
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
    /// - Parameter navigationController: navigation controller that should be embed
    /// - Parameter typeNavigation: naviagtion style
    /// - Parameter animated: animated of transition
    ///
    /// - Important: you have to register module for navigation before usage
    ///
    func navigate<Destination: NGSNavigatable>(
        to _: Destination.Type,
        navigationController: UINavigationController?,
        typeNavigation: NGSTransitionStyle,
        animated: Bool
        )
    
    ///
    /// Load new module to screen based on generic navigation type
    /// - Parameter to: represent target Destination
    /// - Parameter navigationController: navigation controller that should be embed
    /// - Parameter parameter: navigation parameter which pass to next module
    /// - Parameter typeNavigation: naviagtion style
    /// - Parameter animated: animated of transition
    ///
    /// - Important: you have to register module for navigation before usage
    ///
    func navigate<Destination: NGSParamNavigatable>(
        to _: Destination.Type,
        navigationController: UINavigationController?,
        parameter: Destination.Parameter,
        typeNavigation: NGSTransitionStyle,
        animated: Bool
        )
    
    ///
    /// Load new module to screen based on generic navigation type with close closure
    /// - Parameter to: represent target Destination
    /// - Parameter navigationController: navigation controller that should be embed
    /// - Parameter typeNavigation: naviagtion style
    /// - Parameter animated: animated of transition
    /// - Parameter closeCompletion: represent closure which invokes before close opened module
    ///
    /// - Important: you have to register module for navigation before usage
    ///
    func navigate<Destination: NGSCloseNavigatable>(
        to _: Destination.Type,
        navigationController: UINavigationController?,
        typeNavigation: NGSTransitionStyle,
        animated: Bool,
        closeCompletion: @escaping CloseCompletition<Destination.CloseObject>
        )
    
    ///
    /// Load new module to screen based on generic navigation type with close closure
    /// - Parameter to: represent target Destination
    /// - Parameter navigationController: navigation controller that should be embed
    /// - Parameter parameter: navigation parameter which pass to next module
    /// - Parameter typeNavigation: naviagtion style
    /// - Parameter animated: animated of transition
    /// - Parameter closeCompletion: represent closure which invokes before close opened module
    ///
    /// - Important: you have to register module for navigation before usage
    ///
    func navigate<Destination: NGSParamCloseNavigatable>(
        to _: Destination.Type,
        navigationController: UINavigationController?,
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

public extension NGSRouterType {
    
    ///
    /// Load new module to screen based on generic navigation type
    /// - Parameter to: represent target Destination
    /// - Parameter navigationController: navigation controller that should be embed
    /// - Parameter typeNavigation: naviagtion style
    /// - Parameter animated: animated of transition
    ///
    /// - Important: you have to register module for navigation before usage
    ///
    func navigate<Destination: NGSNavigatable>(
        to _: Destination.Type,
        navigationController: UINavigationController? = nil,
        typeNavigation: NGSTransitionStyle = .push,
        animated: Bool = true
        ) {
        
        self.navigate(
            to: Destination.self,
            navigationController: nil,
            typeNavigation: typeNavigation,
            animated: animated
        )
    }
    
    ///
    /// Load new module to screen based on generic navigation type
    /// - Parameter to: represent target Destination
    /// - Parameter navigationController: navigation controller that should be embed
    /// - Parameter parameter: navigation parameter which pass to next module
    /// - Parameter typeNavigation: naviagtion style
    /// - Parameter animated: animated of transition
    ///
    /// - Important: you have to register module for navigation before usage
    ///
    func navigate<Destination: NGSParamNavigatable>(
        to _: Destination.Type,
        navigationController: UINavigationController? = nil,
        parameter: Destination.Parameter,
        typeNavigation: NGSTransitionStyle = .push,
        animated: Bool = true
        ) {
        
        self.navigate(
            to: Destination.self,
            navigationController: nil,
            parameter: parameter,
            typeNavigation: typeNavigation,
            animated: animated
        )
    }
    
    ///
    /// Load new module to screen based on generic navigation type with close closure
    /// - Parameter to: represent target Destination
    /// - Parameter navigationController: navigation controller that should be embed
    /// - Parameter typeNavigation: naviagtion style
    /// - Parameter animated: animated of transition
    /// - Parameter closeCompletion: represent closure which invokes before close opened module
    ///
    /// - Important: you have to register module for navigation before usage
    ///
    func navigate<Destination: NGSCloseNavigatable>(
        to _: Destination.Type,
        navigationController: UINavigationController? = nil,
        typeNavigation: NGSTransitionStyle = .push,
        animated: Bool = true,
        closeCompletion: @escaping CloseCompletition<Destination.CloseObject>
        ) {
        
        self.navigate(
            to: Destination.self,
            navigationController: nil,
            typeNavigation: typeNavigation,
            animated: animated,
            closeCompletion: closeCompletion
        )
    }
    
    ///
    /// Load new module to screen based on generic navigation type with close closure
    /// - Parameter to: represent target Destination
    /// - Parameter navigationController: navigation controller that should be embed
    /// - Parameter parameter: navigation parameter which pass to next module
    /// - Parameter typeNavigation: naviagtion style
    /// - Parameter animated: animated of transition
    /// - Parameter closeCompletion: represent closure which invokes before close opened module
    ///
    /// - Important: you have to register module for navigation before usage
    ///
    func navigate<Destination: NGSParamCloseNavigatable>(
        to _: Destination.Type,
        navigationController: UINavigationController? = nil,
        parameter: Destination.Parameter,
        typeNavigation: NGSTransitionStyle = .push,
        animated: Bool = true,
        closeCompletion: @escaping CloseCompletition<Destination.CloseObject>
        ) {
        
        self.navigate(
            to: Destination.self,
            navigationController: nil,
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
