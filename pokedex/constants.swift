//
//  constants.swift
//  pokedex
//
//  Created by Daniel Cleaves on 12/1/16.
//  Copyright © 2016 Daniel Cleaves. All rights reserved.
//

import Foundation

let URL_BASE = "http://pokeapi.co"
let URL_POKEMON = "/api/v1/pokemon/"

// Creating closure that gets when API finish loading

typealias DownloadComplete = () -> ()
