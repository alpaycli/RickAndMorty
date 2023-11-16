//
//  RMEpisode.swift
//  RickAndMorty
//
//  Created by Alpay Calalli on 16.11.23.
//

import Foundation

struct RMEpisodeResponse: Codable {
    let results: [RMEpisode]
}

struct RMEpisode: Codable, Identifiable {
    let id: Int?
    let name, airDate, episode: String?
    let characters: [String]?
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case airDate = "air_date"
        case episode
        case characters
    }
}

/*
 URL: https://rickandmortyapi.com/api/episode
 {
   "info": {
     "count": 51,
     "pages": 3,
     "next": "https://rickandmortyapi.com/api/episode?page=2",
     "prev": null
   },
   "results": [
     {
       "id": 1,
       "name": "Pilot",
       "air_date": "December 2, 2013",
       "episode": "S01E01",
       "characters": [
         "https://rickandmortyapi.com/api/character/1",
         "https://rickandmortyapi.com/api/character/2",
         //...
       ],
       "url": "https://rickandmortyapi.com/api/episode/1",
       "created": "2017-11-10T12:56:33.798Z"
     },
     // ...
   ]
 }
 */
