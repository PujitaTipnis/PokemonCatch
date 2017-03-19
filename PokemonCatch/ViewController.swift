//
//  ViewController.swift
//  PokemonCatch
//
//  Created by Pujita Tipnis on 3/16/17.
//  Copyright © 2017 Pujita Tipnis. All rights reserved.
//

import UIKit
import MapKit

class ViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {

    @IBOutlet weak var mapView: MKMapView!
    
    var manager = CLLocationManager()
    var updateCount = 0
    var pokemons : [Pokemon] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        pokemons = getAllPokemon()
        manager.delegate = self
        
        if CLLocationManager.authorizationStatus() == .authorizedWhenInUse {
            setUp()
        } else {
            manager.requestWhenInUseAuthorization()
        }
        
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse {
            setUp()
        }
    }
    
    func setUp() {
        mapView.delegate = self
        mapView.showsUserLocation = true
        manager.startUpdatingLocation()
        
        Timer.scheduledTimer(withTimeInterval: 5, repeats: true, block: { (timer) in
            // spawn a Pokemon
            
            if let coord = self.manager.location?.coordinate {
                let pokemon = self.pokemons[Int(arc4random_uniform(UInt32(self.pokemons.count)))]
                let annotn = PokeAnnotation(coord: coord, pokemon: pokemon)
                let randomLat = (Double(arc4random_uniform(200)) - 100.0) / 50000.0
                let randomLong = (Double(arc4random_uniform(200)) - 100.0) / 50000.0
                annotn.coordinate.latitude += randomLat
                annotn.coordinate.longitude += randomLong
                self.mapView.addAnnotation(annotn)
            }
            
        })
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        if annotation is MKUserLocation {
            let annotnView = MKAnnotationView(annotation: annotation, reuseIdentifier: nil)
            annotnView.image = UIImage(named: "player")
            
            annotnView.frame.size.height = 45
            annotnView.frame.size.width = 45
            
            return annotnView
        }
        
        let annotnView = MKAnnotationView(annotation: annotation, reuseIdentifier: nil)
        let pokemon = (annotation as! PokeAnnotation).pokemon
        annotnView.image = UIImage(named: pokemon.imageName!)
        
        annotnView.frame.size.height = 45
        annotnView.frame.size.width = 45
        
        return annotnView
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if updateCount < 3 {
            let region = MKCoordinateRegionMakeWithDistance(manager.location!.coordinate, 200, 200)
            mapView.setRegion(region, animated: false)
            updateCount += 1
        } else {
            // with the below function call, the blue dot still continues to move
            // but stopping manager from updating location saves battery
            manager.stopUpdatingLocation()
        }
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        mapView.deselectAnnotation(view.annotation!, animated: true)
        
        if view.annotation! is MKUserLocation {
            return
        }
        
        let region = MKCoordinateRegionMakeWithDistance(view.annotation!.coordinate, 200, 200)
        mapView.setRegion(region, animated: true)
        
        Timer.scheduledTimer(withTimeInterval: 1, repeats: false) { (timer) in
            if let coord = self.manager.location?.coordinate {
                
                let pokemon = (view.annotation as! PokeAnnotation).pokemon
                
                if MKMapRectContainsPoint(mapView.visibleMapRect, MKMapPointForCoordinate(coord)) {
                    // Can catch the Pokemon
                    
                    pokemon.caught = true
                    (UIApplication.shared.delegate as! AppDelegate).saveContext()
                    
                    mapView.removeAnnotation(view.annotation!)
                    
                    let alertVC = UIAlertController(title: "Congrats!", message: "You caught a \(pokemon.name!). You are a Pokemon Master!", preferredStyle: .alert)
                    
                    let pokedexAction = UIAlertAction(title: "Pokedex", style: .default, handler: {(action) in
                        self.performSegue(withIdentifier: "pokedexSegue", sender: nil)
                    })
                    alertVC.addAction(pokedexAction)
                    
                    let OKAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
                    alertVC.addAction(OKAction)
                    self.present(alertVC, animated: true, completion: nil)
                    
                } else {
                    //Pokemon too far away
                    let alertVC = UIAlertController(title: "Oops!", message: "You are too far away to catch the \(pokemon.name!). Move closer to it!", preferredStyle: .alert)
                    let OKAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
                    alertVC.addAction(OKAction)
                    self.present(alertVC, animated: true, completion: nil)
                }
            }
        }

    }

    @IBAction func centerTapped(_ sender: Any) {
        if let coord = manager.location?.coordinate {
            let region = MKCoordinateRegionMakeWithDistance(coord, 200, 200)
            mapView.setRegion(region, animated: true)
        }
    }
}

