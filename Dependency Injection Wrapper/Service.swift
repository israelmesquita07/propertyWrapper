//
//  Service.swift
//  Dependency Injection Wrapper
//
//  Created by Israel Pinheiro Mesquita on 01/05/21.
//

import Foundation

public struct Service {
    
    public enum LifeCycle {
        case global
        case oneOf
    }
    
    /// Holds the lifecycle of the current service
    public var cycle: LifeCycle
    
    /// Unique name for each service
    public let name: ObjectIdentifier
    
    /// The closure that will resolve the service
    private let resolve: (Dependencies) -> Any
    
    var instance: Any?
    
    func createInstance(d: Dependencies) -> Any {
        return resolve(d)
    }
    
    /// Initialize a service with a resolver
    public init<Service>(_ cycle: LifeCycle = .oneOf, _ resolve: @escaping (Dependencies) -> Service) {
        
        self.name = ObjectIdentifier(Service.self)
        self.resolve = resolve
        self.cycle = cycle
    }
}
