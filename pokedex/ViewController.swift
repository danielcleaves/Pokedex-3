//
//  ViewController.swift
//  pokedex
//
//  Created by Daniel Cleaves on 11/28/16.
//  Copyright © 2016 Daniel Cleaves. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UISearchBarDelegate {
    
    @IBOutlet weak var collection: UICollectionView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    // Creating pokemon array
    
    var pokemon = [Pokemon]()
    var musicPlayer: AVAudioPlayer!
    var filteredPokemon = [Pokemon]()
    var inSearchMode = false

    override func viewDidLoad() {
        super.viewDidLoad()
        
        collection.dataSource = self
        collection.delegate = self
        searchBar.delegate = self
        
        searchBar.returnKeyType = UIReturnKeyType.done
        
        
        parsePokemonCSV()
        initAudio()
        
    }
    
    // Gets audio ready
    
    func initAudio() {
        
        let path = Bundle.main.path(forResource: "music", ofType: "mp3")
        
        do {
            musicPlayer = try AVAudioPlayer(contentsOf: URL(string:path!)!)
            musicPlayer.prepareToPlay()
            musicPlayer.numberOfLoops = -1
            musicPlayer.play()
        } catch let err as NSError {
            print(err.debugDescription)
        }
        
    }
    
    // Parse Pokemon CSV files to get pokemon data
    
    func parsePokemonCSV() {
        let path = Bundle.main.path(forResource: "pokemon", ofType: "csv")!
        
        do {
            let csv = try CSV(contentsOfURL: path)
            let rows = csv.rows
            print(rows)
            
            // Going through each row to get poke id and name
            
            for row in rows {
                let pokeId = Int(row["id"]!)!
                let name = row["identifier"]!
                
                // Create and attach Poke into pokemon array
                
                let poke = Pokemon(name: name, pokedexId: pokeId)
                pokemon.append(poke)
            }
            
        } catch let err as NSError {
            print(err.debugDescription)
        }
    }
    
    // dequeue cells and stops application from using too much memory and crashing

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PokeCell", for: indexPath) as? PokeCell {
           
    // Calls collection view cell and passes in Pokemon created
            let poke: Pokemon!
            if inSearchMode {
                
                poke = filteredPokemon[indexPath.row]
                cell.configureCell(poke)
            } else {
                poke = pokemon[indexPath.row]
                cell.configureCell(poke)
            }
            
            
            return cell
            
        } else {
            return UICollectionViewCell()
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        var poke: Pokemon!
        
        if inSearchMode {
           
            poke = filteredPokemon[indexPath.row]
            
        } else {
            poke = pokemon[indexPath.row]
        }
        
        performSegue(withIdentifier: "PokemonDetailVC", sender: poke)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if inSearchMode {
            return filteredPokemon.count
        }
        
        return pokemon.count
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: 105, height: 105)
    }
    @IBAction func musicBtnPressed(_ sender: UIButton) {
        if musicPlayer.isPlaying {
            musicPlayer.pause()
    // Makes the button transparent when paused
            sender.alpha = 0.2
        } else {
            musicPlayer.play()
            sender.alpha = 1.0
        }
    }
    
    // Ends editing and keyboard goes away
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        view.endEditing(true)
    }
    
    // Implementing search bar
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        if searchBar.text == nil || searchBar.text == "" {
            inSearchMode = false
            collection.reloadData()
        // keyboard is removed
            view.endEditing(true)
        } else {
            inSearchMode = true
            
            let lower = searchBar.text!.lowercased()
            
            // Filtered pokemon list is going to be equal to the original pokemon list, filtering it based on whether the text is included in the arrays original's name
            filteredPokemon = pokemon.filter({$0.name.range(of: lower) != nil})
            collection.reloadData()
            
        }
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "PokemonDetailVC" {
            if let detailsVC = segue.destination as? PokemonDetailVC {
                if let poke  = sender as? Pokemon {
                    detailsVC.pokemon = poke
                }
            }
        }
    }

}

