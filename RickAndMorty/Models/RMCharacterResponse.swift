//
//  RMCharacterResponse.swift
//  RickAndMorty
//
//  Created by Alpay Calalli on 14.11.23.
//

import Foundation

struct RMCharacterResponse: Codable {
    let info: Info
    let results: RMCharacterResult
}

struct Info: Codable {
    let next: String?
    let prev: String?
}

struct RMCharacterResult: Codable, Identifiable {
    let id: Int
    let name: String
    let status: String
    let species: String
    let type: String
    let gender: String
    let orign: Orign
    let location: Location
    let image: String
    let episode: [String]
    let created: String
}

struct Orign: Codable {
    let name: String
    let url: String
}

struct Location: Codable {
    let name: String
    let url: String
}

/*
 URL: https://rickandmortyapi.com/api/character/?page=19
 {
   "info": {
     "count": 826,
     "pages": 42,
     "next": "https://rickandmortyapi.com/api/character/?page=20",
     "prev": "https://rickandmortyapi.com/api/character/?page=18"
   },
   "results": [
     {
       "id": 361,
       "name": "Toxic Rick",
       "status": "Dead",
       "species": "Humanoid",
       "type": "Rick's Toxic Side",
       "gender": "Male",
       "origin": {
         "name": "Alien Spa",
         "url": "https://rickandmortyapi.com/api/location/64"
       },
       "location": {
         "name": "Earth",
         "url": "https://rickandmortyapi.com/api/location/20"
       },
       "image": "https://rickandmortyapi.com/api/character/avatar/361.jpeg",
       "episode": [
         "https://rickandmortyapi.com/api/episode/27"
       ],
       "url": "https://rickandmortyapi.com/api/character/361",
       "created": "2018-01-10T18:20:41.703Z"
     },
     // ...
   ]
 }
 
 */
