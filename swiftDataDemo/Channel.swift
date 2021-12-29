//
//  Channel.swift
//  Test
//
//  Created by bayareahank on 12/13/21.
//

import Foundation

struct Channel: Codable {
    let id:         Int
    let name:       String
    let imageUrl:   String      // URL  (can parse directly into URL if so)
    let optional:   String?     // may have, may not.
}

// This way we can use JSON decode
// let blogPosts: [BlogPost] = try! JSONDecoder().decode([BlogPost].self, from: jsonData)
// let blogPost: BlogPost = try! JSONDecoder().decode(BlogPost.self, from: jsonData)

// This one covers the case of list with key
struct ChannelList: Codable {
    let Channels: [Channel]
}

/*
// Codable is a typealias for Encodable & Decodable
struct PagedBreweries: Codable {
    struct Meta: Codable {
        let page: Int
        let totalRecords: Int
        enum CodingKeys: String, CodingKey {
            case page 
            case totalRecords = "total_records"
        }
    }
    
    struct Brewery: Codable {
        let id: Int
        let name: String
    }
    
    let meta: Meta
    let breweries: [Brewery]
}
*/
