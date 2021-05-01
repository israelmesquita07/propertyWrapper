//
//  Dependencies.swift
//  Dependency Injection Wrapper
//
//  Created by Israel Pinheiro Mesquita on 01/05/21.
//

import Foundation

public final class Dependencies {
    
    /// Will hold all our factories
    public var factories: [ObjectIdentifier : Service] = [:]
    
    /// Make sure that our init will stay private so they need to use the provider functionBuilder
    private init() { }
    
    /// Make sure that all the dependencies are removed when we deinit
    deinit {
        factories.removeAll()
    }
}

// MARK: - Private extension
private extension Dependencies {
    
    /// Resolve a serice based on its ObjectIdentifier
    func resolve<Service>() -> Service {
        
        var service = self.factories[ObjectIdentifier(Service.self)]!
        
        guard let instance = service.instance, service.cycle == .global else {
            service.instance = service.createInstance(d: self)
            self.factories[service.name] = service
            return service.instance as! Service
        }
        return instance as! Service
    }
    
    /// Register a service with our resolver
    private func register(_ service: Service) {
        self.factories[service.name] = service
    }
}

// MARK: - Public extension
public extension Dependencies {
    
    /// Create a overridable main resolver
    fileprivate static var main = Dependencies()
    
    func get<Service>() -> Service {
        return resolve()
    }
    
    /// Function builder that accepts a single or multiple services
    @_functionBuilder struct DependencyBuilder {
        public static func buildBlock(_ services: Service...) -> [Service] { services }
        public static func buildBlock(_ service: Service) -> Service { service }
    }
    
    /// Convienience init with our service builder
    convenience init(@DependencyBuilder _ services: () -> [Service]) {
        self.init()
        services().forEach { register($0) }
    }
    
    /// Convienience init with our service builder
    convenience init(@DependencyBuilder _ service: () -> Service) {
        self.init()
        register(service())
    }
    
    /// Build our graph
    func build() {
        Self.main = self
    }
}

@propertyWrapper
struct Injected<Service> {
    
    typealias DelayedInjection = () -> Service
    
    var service: Service?
    var delayed: DelayedInjection?
    
    init() {
        delayed = { Dependencies.main.resolve() }
    }
    
    var wrappedValue: Service {
        mutating get {
            if let service = service {
                return service
            } else if let delayed = delayed {
                service = delayed()
                return service!
            } else {
                fatalError()
            }
        }
    }
}
