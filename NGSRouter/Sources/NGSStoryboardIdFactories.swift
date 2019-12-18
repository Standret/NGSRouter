//
//  NGSStoryboardIdFactories.swift
//  NGSRouter
//
//  Created by Peter Standret on 8/18/19.
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

public class NGSPresenterStoryboardIdFactory: NGSStoryboardIdFactory {
    
    public init() { }
    
    public func getStoryboardId<Navigatable: NGSNavigatable>(
        object _: Navigatable.Type
        ) -> String {
        
        let objectName = "\(type(of: Navigatable.self))".components(separatedBy: ".").first!
        return String(objectName[..<(objectName.index(objectName.endIndex, offsetBy: -9))])
    }
    
    public func getStoryboardId<Navigatable: NGSNavigatable>(
        storyboard: NGSStoryboard,
        object _: Navigatable.Type
        ) -> String {
        
        return self.getStoryboardId(object: Navigatable.self)
    }
}

public class NGSViewControllerStoryboardIdFactory: NGSStoryboardIdFactory {
    
    public init() { }

    public func getStoryboardId<Navigatable: NGSNavigatable>(
        object _: Navigatable.Type
        ) -> String {
        
        let objectName = "\(type(of: Navigatable.self))".components(separatedBy: ".").first!
        return String(objectName[..<(objectName.index(objectName.endIndex, offsetBy: -14))])
    }
    
    public func getStoryboardId<Navigatable: NGSNavigatable>(
        storyboard: NGSStoryboard,
        object _: Navigatable.Type
        ) -> String {
        
        return self.getStoryboardId(object: Navigatable.self)
    }
}
