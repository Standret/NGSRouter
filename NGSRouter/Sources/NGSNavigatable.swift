//
//  NGSTransitionPreperable.swift
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
public protocol NGSNavigatable: AnyObject {
    
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
    
    public func invoke(with parameter: T) {
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
