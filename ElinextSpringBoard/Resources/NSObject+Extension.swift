//
//  NSObject+Extension.swift
//  ElinextSpringBoard
//
//  Created by Mike Makhovyk on 16.02.2021.
//

import Foundation

public extension NSObject {
    var className: String {
        return String(describing: type(of: self))
    }
    
    class var className: String {
        return String(describing: self)
    }
}
