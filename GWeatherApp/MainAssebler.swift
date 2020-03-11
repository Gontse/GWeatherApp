//
//  MainAssebler.swift
//  GWeatherApp
//
//  Created by Gontze on 2020/03/09.
//  Copyright © 2020 Gontze. All rights reserved.
//

import Foundation
import Swinject
import SwinjectStoryboard

class MainAssembler {
    
    var resolver: Resolver {
        return assembler.resolver
    }
    
    private let assembler = Assembler(container: SwinjectStoryboard.defaultContainer)
    
    init() {
        assembler.apply(assembly: GWALocationManagerAssembly())
        assembler.apply(assembly: GWALocationAuthorizationAssembly())
        assembler.apply(assembly: GWALocationProviderAssembly())
        assembler.apply(assembly: MainViewControllerAssembly())
        assembler.apply(assembly: GWAWeatherProviderAssembly())
     
    }
    
}
