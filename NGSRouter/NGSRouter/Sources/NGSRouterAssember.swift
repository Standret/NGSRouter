//
//  NGSRouterAssember.swift
//  NGSRouter
//
//  Created by Peter Standret on 8/8/19.
//  Copyright © 2019 Piter Standret. All rights reserved.
//

import Foundation
import UIKit

final public class NGSRouterAssember {
    
    public typealias NGSVCFactoryResolver = () -> UIViewController
    public typealias NGSStoryboardData = (storyboard: String, storyboardId: String)
    
    private var storyboardRegistration = [String: String]()
    private var vcRegistration = [String: NGSVCFactoryResolver]()

    private init() { }
    
    public static var shared = NGSRouterAssember()
    
    public func register<Navigatable: NGSNavigatable>(
        storyboard: NGSStoryboard,
        Navigatable: Navigatable.Type
        ) {
        
        storyboardRegistration[getTargetVCId(to: Navigatable.self)] = storyboard.name
    }
    
    public func register<Navigatable: NGSNavigatable>(
        navigatable _: Navigatable.Type,
        factory: @escaping NGSVCFactoryResolver
        ) {
        
        vcRegistration[getTargetVCId(to: Navigatable.self)] = factory
    }
    
    public func fetchStoryboard<Navigatable: NGSNavigatable>(navigatable _: Navigatable.Type) -> NGSStoryboardData? {
        
        let storyboardId = getTargetVCId(to: Navigatable.self)
        if let stroyboardName = storyboardRegistration[storyboardId] {
            return (storyboard: stroyboardName, storyboardId: storyboardId)
        }
        
        return nil
    }
    
    public func fetchVCRegistration<Navigatable: NGSNavigatable>(navigatable _: Navigatable.Type) -> NGSVCFactoryResolver? {
        
        let storyboardId = getTargetVCId(to: Navigatable.self)
        return vcRegistration[storyboardId]
    }
    
    internal func getTargetVCId<Navigatable: NGSNavigatable>(to _: Navigatable.Type) -> String {
        
        return NGSRouterConfig.shared.storyboardIdFactory.getStoryboardId(object: Navigatable.self)
    }
}
