//
//  RMCharacterResponse.swift
//  RickAndMorty
//
//  Created by Alpay Calalli on 14.11.23.
//

import Foundation

struct RMCharacterResponse: Codable {
    let results: [RMCharacter]
}

struct RMCharacter: Codable, Identifiable, Hashable {
    let id: Int?
    let name, status, species, type, gender, image, url, created: String?
    let orign: Orign?
    let location: Location?
    let episode: [String]?
    
    struct Orign: Codable, Hashable {
        let name, url: String
    }

    struct Location: Codable, Hashable {
        let name, url: String
    }
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
