//
//  PokedexViewController.swift
//  PokemonCatch
//
//  Created by Pujita Tipnis on 3/17/17.
//  Copyright © 2017 Pujita Tipnis. All rights reserved.
//

import UIKit

class PokedexViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    
    var caughtPokemon : [Pokemon] = []
    var uncaughtPokemon : [Pokemon] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        caughtPokemon = getAllCaughtPokemons()
        uncaughtPokemon = getAllUncaughtPokemons()
        
        // Do any additional setup after loading the view.
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return "CAUGHT"
        } else {
            return "UNCAUGHT"
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return caughtPokemon.count
        } else {
            return uncaughtPokemon.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let pokemon : Pokemon
        
        if indexPath.section == 0 {
            pokemon = caughtPokemon[indexPath.row]
        } else {
            pokemon = uncaughtPokemon[indexPath.row]
        }
        
        let cell = UITableViewCell()
        cell.textLabel?.text = pokemon.name
        cell.imageView?.image = UIImage(named: pokemon.imageName!)
        
        return cell
    }

    @IBAction func mapTapped(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}
