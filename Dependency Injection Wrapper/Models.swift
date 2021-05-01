//
//  Models.swift
//  Dependency Injection Wrapper
//
//  Created by Israel Pinheiro Mesquita on 01/05/21.
//

import Foundation

protocol WorkProtocol: AnyObject {
    func work()
}

final class ViewModel {
    weak var delegate: WorkProtocol?
}

struct Bar {
    let name: String = "test"
}

struct Foo {
    let bar: Bar
}
