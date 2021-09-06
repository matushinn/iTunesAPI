//
//  Song.swift
//  iTunesAPI
//
//  Created by 大江祥太郎 on 2021/09/06.
//

import Foundation

struct Songs :Codable{
    let results:[Song]
}

struct Song :Codable{
    let artistName :String?
    let trackCensoredName:String?
    let previewUrl:String?
    let artworkUrl100:String
    
    var artworkImageUrl100:URL?{
        return URL(string: artworkUrl100)
    }
    
}
