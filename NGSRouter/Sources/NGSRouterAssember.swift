//
//  NGSRouterAssember.swift
//  NGSRouter
//
//  Created by Peter Standret on 8/8/19.
//  Copyright © 2019 Piter Standret. All rights reserved.
//

import Foundation
import UIKit

open class NGSRouterAssember {
    
    public typealias NGSVCFactoryResolver = () -> UIViewController
    public typealias NGSStoryboardData = (storyboard: String, storyboardId: String)
    public typealias NGSDestinatableInjector<T> = (T) -> Void
    
    internal typealias NGSApplier = (Any) -> Void
    
    private var storyboardRegistration = [String: String]()
    private var vcRegistration = [String: NGSVCFactoryResolver]()
    private var configuratorRegistration = [String: NGSApplier]()
    
    public private(set) static var `default` = NGSRouterAssember()

    public init() { }
    
    public func replaceDefaultAssembler(_ assembler: NGSRouterAssember) {
        NGSRouterAssember.default = assembler
    }
        
    open func register<Navigatable: NGSNavigatable>(
        _ navigatable: Navigatable.Type,
        storyboard: NGSStoryboard
        ) {
        
        let targetKey = getTargetVCId(to: Navigatable.self)
        guard !storyboardRegistration.keys.contains(targetKey) else {
            fatalError("Attempt registration \(type(of: Navigatable.self)) the destination was already registered.")
        }
        
        storyboardRegistration[targetKey] = storyboard.name
    }
    
    open func register<Navigatable: NGSNavigatable, Destinatable>(
        _ navigatable: Navigatable.Type,
        storyboard: NGSStoryboard,
        conigurator: @escaping NGSDestinatableInjector<Destinatable>
        ) {
        
        self.register(
            Navigatable.self,
            storyboard: storyboard
        )
        
        self.registerConfigurator(
            Navigatable.self,
            conigurator: conigurator
        )
    }
    
    open func register<Navigatable: NGSNavigatable>(
        _: Navigatable.Type,
        factory: @escaping NGSVCFactoryResolver
        ) {
        
        let targetKey = getTargetVCId(to: Navigatable.self)
        guard !vcRegistration.keys.contains(targetKey) else {
            fatalError("Attempt registration \(type(of: Navigatable.self)) the destination was already registered.")
        }
        
        vcRegistration[targetKey] = factory
    }
    
    open func register<Navigatable: NGSNavigatable, Destinatable>(
        _: Navigatable.Type,
        factory: @escaping NGSVCFactoryResolver,
        conigurator: @escaping NGSDestinatableInjector<Destinatable>
        ) {
        
        self.register(
            Navigatable.self,
            factory: factory
        )
        
        self.registerConfigurator(
            Navigatable.self,
            conigurator: conigurator
        )
    }
    
    internal func fetchStoryboard<Navigatable: NGSNavigatable>(_: Navigatable.Type) -> NGSStoryboardData? {
        
        let storyboardId = getTargetVCId(to: Navigatable.self)
        if let stroyboardName = storyboardRegistration[storyboardId] {
            return (storyboard: stroyboardName, storyboardId: storyboardId)
        }
        
        return nil
    }
    
    internal func fetchVCRegistration<Navigatable: NGSNavigatable>(_: Navigatable.Type) -> NGSVCFactoryResolver? {
        
        let storyboardId = getTargetVCId(to: Navigatable.self)
        return vcRegistration[storyboardId]
    }
    
    internal func fetchConfigurator<Navigatable: NGSNavigatable>(_: Navigatable.Type) -> NGSApplier? {
        
        let storyboardId = getTargetVCId(to: Navigatable.self)
        return configuratorRegistration[storyboardId]
    }
    
    internal func getTargetVCId<Navigatable: NGSNavigatable>(to _: Navigatable.Type) -> String {
        
        return NGSRouterConfig.shared.storyboardIdFactory.getStoryboardId(object: Navigatable.self)
    }
    
    private func registerConfigurator<Navigatable: NGSNavigatable, Destinatable>(
        _: Navigatable.Type,
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
    
    // MARK: - deprecated
    
    @available(swift, deprecated: 5, obsoleted: 6, renamed: "default")
    public static var shared: NGSRouterAssember { return NGSRouterAssember.default }
    
    @available(swift, deprecated: 5, obsoleted: 6, renamed: "register(_:navigatable:)")
    public func register<Navigatable: NGSNavigatable>(
        storyboard: NGSStoryboard,
        navigatable: Navigatable.Type
    ) {
        self.register(Navigatable.self, storyboard: storyboard)
    }
    
    @available(swift, deprecated: 5, obsoleted: 6, renamed: "register(_:storyboard:conigurator:)")
    public func register<Navigatable: NGSNavigatable, Destinatable>(
        storyboard: NGSStoryboard,
        navigatable: Navigatable.Type,
        conigurator: @escaping NGSDestinatableInjector<Destinatable>
        ) {
        
        self.register(Navigatable.self, storyboard: storyboard, conigurator: conigurator)
    }
    
    @available(swift, deprecated: 5, obsoleted: 6, renamed: "register(_:factory:)")
    public func register<Navigatable: NGSNavigatable>(
        navigatable _: Navigatable.Type,
        factory: @escaping NGSVCFactoryResolver
        ) {
        
        self.register(Navigatable.self, factory: factory)
    }
    
    @available(swift, deprecated: 5, obsoleted: 6, renamed: "register(_:factory:conigurator:)")
    public func register<Navigatable: NGSNavigatable, Destinatable>(
        navigatable _: Navigatable.Type,
        factory: @escaping NGSVCFactoryResolver,
        conigurator: @escaping NGSDestinatableInjector<Destinatable>
        ) {
        
        self.register(Navigatable.self, factory: factory, conigurator: conigurator)
    }
}
