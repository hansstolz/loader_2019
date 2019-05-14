//
//  Genre.swift
//  Async
//
//  Created by go on 14.05.19.
//

import Foundation
import MySQL


final class Genre:Codable,MySQLTable {
    static var entity: String {
        return "Genre"
    }
    
    typealias ID = Int
    
    var id:Int?
    let genre:String
    let bands:[Int]
    
    init(genre:String,bands:[Int]) {
        self.genre=genre.replacingOccurrences(of: "_", with: "/")
        self.bands=bands
    }

}
