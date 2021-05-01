//
//  ViewController.swift
//  Dependency Injection Wrapper
//
//  Created by Israel Pinheiro Mesquita on 01/05/21.
//

import UIKit

final class ViewController: UIViewController {
    
    @Injected var viewModel: ViewModel
    @Injected var foo: Foo
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        buildServiceDependencies()
        
        print(foo.bar.name)
        viewModel.delegate = self
        
        /// Call implementation
        viewModel.delegate?.work()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        present(ViewController2(), animated: true, completion: nil)
    }
    
    private func buildServiceDependencies() {
        Dependencies {
            Service { _ in Bar.init() }
            Service { Foo(bar: $0.get()) }
            Service(.global) { _ in ViewModel.init() }
        }.build()
    }
}

// MARK: - WorkProtocol
extension ViewController: WorkProtocol {
    func work() {
        print("I'm working")
    }
}

// MARK: - Test with other N ViewControllers
final class ViewController2: UIViewController {
    
    @Injected var viewModel: ViewModel
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel.delegate?.work()
    }
}
