//
//  PokeAnnotation.swift
//  PokemonCatch
//
//  Created by Pujita Tipnis on 3/17/17.
//  Copyright © 2017 Pujita Tipnis. All rights reserved.
//

import UIKit
import MapKit

class PokeAnnotation : NSObject, MKAnnotation {
    var coordinate: CLLocationCoordinate2D
    var pokemon: Pokemon
    
    init(coord : CLLocationCoordinate2D, pokemon: Pokemon) {
        self.coordinate = coord
        self.pokemon = pokemon
    }
}
