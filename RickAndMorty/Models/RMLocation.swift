//
//  RMLocation.swift
//  RickAndMorty
//
//  Created by Alpay Calalli on 15.11.23.
//

import Foundation

struct RMLocationResponse: Codable {
    let results: [RMLocation]
}

struct RMLocation: Codable, Identifiable {
    let id: Int?
    let name, type, dimension, url, created: String?
    let residents: [String]?
}

/*
 "info": {
     "count": 126,
     "pages": 7,
     "next": "https://rickandmortyapi.com/api/location?page=2",
     "prev": null
   },
   "results": [
     {
       "id": 1,
       "name": "Earth",
       "type": "Planet",
       "dimension": "Dimension C-137",
       "residents": [
         "https://rickandmortyapi.com/api/character/1",
         "https://rickandmortyapi.com/api/character/2",
         // ...
       ],
       "url": "https://rickandmortyapi.com/api/location/1",
       "created": "2017-11-10T12:42:04.162Z"
     }
     // ...
   ]
 }
 */
