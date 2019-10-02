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
    public typealias NGSDestinatableInjector<T> = (T) -> Void
    
    internal typealias NGSApplier = (Any) -> Void
    
    private var storyboardRegistration = [String: String]()
    private var vcRegistration = [String: NGSVCFactoryResolver]()
    private var configuratorRegistration = [String: NGSApplier]()

    private init() { }
    
    public static var shared = NGSRouterAssember()
    
    public func register<Navigatable: NGSNavigatable>(
        storyboard: NGSStoryboard,
        navigatable: Navigatable.Type
        ) {
        
        let targetKey = getTargetVCId(to: Navigatable.self)
        guard !storyboardRegistration.keys.contains(targetKey) else {
            fatalError("Attempt registration \(type(of: Navigatable.self)) the destination which was already registered.")
        }
        
        storyboardRegistration[targetKey] = storyboard.name
    }
    
    public func register<Navigatable: NGSNavigatable, Destinatable>(
        storyboard: NGSStoryboard,
        navigatable: Navigatable.Type,
        conigurator: @escaping NGSDestinatableInjector<Destinatable>
        ) {
        
        self.register(
            storyboard: storyboard,
            navigatable: navigatable.self
        )
        
        self.registerConfigurator(
            navigatable: Navigatable.self,
            conigurator: conigurator
        )
    }
    
    public func register<Navigatable: NGSNavigatable>(
        navigatable _: Navigatable.Type,
        factory: @escaping NGSVCFactoryResolver
        ) {
        
        let targetKey = getTargetVCId(to: Navigatable.self)
        guard !vcRegistration.keys.contains(targetKey) else {
            fatalError("Attempt registration \(type(of: Navigatable.self)) the destination which was already registered.")
        }
        
        vcRegistration[targetKey] = factory
    }
    
    public func register<Navigatable: NGSNavigatable, Destinatable>(
        navigatable _: Navigatable.Type,
        factory: @escaping NGSVCFactoryResolver,
        conigurator: @escaping NGSDestinatableInjector<Destinatable>
        ) {
        
        self.register(
            navigatable: Navigatable.self,
            factory: factory
        )
        
        self.registerConfigurator(
            navigatable: Navigatable.self,
            conigurator: conigurator
        )
    }
    
    internal func fetchStoryboard<Navigatable: NGSNavigatable>(navigatable _: Navigatable.Type) -> NGSStoryboardData? {
        
        let storyboardId = getTargetVCId(to: Navigatable.self)
        if let stroyboardName = storyboardRegistration[storyboardId] {
            return (storyboard: stroyboardName, storyboardId: storyboardId)
        }
        
        return nil
    }
    
    internal func fetchVCRegistration<Navigatable: NGSNavigatable>(navigatable _: Navigatable.Type) -> NGSVCFactoryResolver? {
        
        let storyboardId = getTargetVCId(to: Navigatable.self)
        return vcRegistration[storyboardId]
    }
    
    internal func fetchConfigurator<Navigatable: NGSNavigatable>(navigatable _: Navigatable.Type) -> NGSApplier? {
        
        let storyboardId = getTargetVCId(to: Navigatable.self)
        return configuratorRegistration[storyboardId]
    }
    
    internal func getTargetVCId<Navigatable: NGSNavigatable>(to _: Navigatable.Type) -> String {
        
        return NGSRouterConfig.shared.storyboardIdFactory.getStoryboardId(object: Navigatable.self)
    }
    
    private func registerConfigurator<Navigatable: NGSNavigatable, Destinatable>(
        navigatable _: Navigatable.Type,
        conigurator: @escaping NGSDestinatableInjector<Destinatable>
        ) {
        
        let targetKey = getTargetVCId(to: Navigatable.self)
        guard !configuratorRegistration.keys.contains(targetKey) else {
            fatalError("Attempt registration \(type(of: Navigatable.self)) the destination which was already registered.")
        }
        
        configuratorRegistration[targetKey] = { output in
            if let output = output as? Destinatable {
                conigurator(output)
            }
            else {
                fatalError("Destination VC: \(type(of: output)) expect \(type(of: Destinatable.self))")
            }
        }
    }
}
