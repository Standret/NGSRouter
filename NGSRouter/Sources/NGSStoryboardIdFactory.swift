//
//  NGSStoryboardIdFactory.swift
//  NGSRouter
//
//  Created by Peter Standret on 8/8/19.
//  Copyright © 2019 Piter Standret. All rights reserved.
//

import Foundation

///
/// This protocol describe methods to get storyboard id based on passed navigation data
///
public protocol NGSStoryboardIdFactory {
    
    func getStoryboardId<Navigatable: NGSNavigatable>(
        object _: Navigatable.Type) -> String
    
    func getStoryboardId<Navigatable: NGSNavigatable>(
        storyboard: NGSStoryboard,
        object _: Navigatable.Type) -> String
}
