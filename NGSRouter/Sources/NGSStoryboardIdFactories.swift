//
//  NGSStoryboardIdFactories.swift
//  NGSRouter
//
//  Created by Peter Standret on 8/18/19.
//  Copyright © 2019 NGS. All rights reserved.
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
