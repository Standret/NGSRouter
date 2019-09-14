//
//  NGSTransitionPreperable.swift
//  NGSRouter
//
//  Created by Peter Standret on 8/8/19.
//  Copyright © 2019 Piter Standret. All rights reserved.
//

import Foundation

///
/// This protocol describe storyboard abstraction for navigation
///
public protocol NGSStoryboard {
    
    ///
    /// Storyboard name in project
    ///
    var name: String { get }
}

///
/// This protocol describe ability for navigation
///
public protocol NGSNavigatable: class {
    
    ///
    /// This function call before navigation
    ///
    func prepare()
}

///
/// This protocol describe ability for navigate with parameter
///
public protocol NGSParamNavigatable: NGSNavigatable {
    
    associatedtype Parameter
    
    ///
    /// This function call before navigation and pass parameter
    /// - Important: This function call after prepare()
    ///
    func prepare(parameter: Parameter)
}

///
/// Represent object which use for close navigation
///
public struct NGSCloseObject<T> {
    
    public typealias CloseClosure = (T) -> Void
    
    public init() {
        self.init(closeClosure: { _ in })
    }
    
    init(closeClosure: @escaping CloseClosure) {
        self.closeClosure = closeClosure
    }
    
    func invoke(with parameter: T) {
        closeClosure(parameter)
    }
    
    private let closeClosure: CloseClosure
}


///
/// This protocol describe ability to close module with parameter
///
public protocol NGSCloseNavigatable: NGSNavigatable {
    
    associatedtype CloseObject
    
    var closableObject: NGSCloseObject<CloseObject> { get set }
}

public typealias NGSParamCloseNavigatable = NGSParamNavigatable & NGSCloseNavigatable
