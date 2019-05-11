//
//  Band.swift
//  Async
//
//  Created by go on 12.06.18.
//

import Foundation
import MySQL


final class Band:Codable,MySQLTable {
    static let baseURL="https://umsonst-und-draussen.de/band_bilderupload"
    static var entity: String {
        return "Band"
    }
    
    typealias ID = Int
    
    var id:Int?
    let Bandname:String
    let Bühne:String
    let Tag:String
    let Auftritt:String
    let Webseite:String?
    let Facebook:String?
    let Instagram:String?
    let Youtube2:String?
    let Youtube3:String?
    let Subhead:String
    let Text:String
    let bild1:String?
    let Bild_1:String?
    let Bild_2:String?
    let Tags:String?
    let related_1:String?
    let related_2:String?
    let related_3:String?
    let Timestamp:String
    var related:[Int]?
    
    var imgURL:String? {
        if let image=bild1?.replacingOccurrences(of: "/", with: "").addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) {
            return "\(Band.baseURL)/\(image)"
        }
        return nil
    }
}

final class BandJSON : Codable {
    
    var band_id: String=""
    var termin:String=""
    var bandname:String=""
    var buehne:String=""
    var kurztext:String=""
    var beschreibung:String=""
    var links:[String]=[String]()
    var genre:[String]=[String]()
    var bilder:[String]=[String]()
    
}

final class Bands : Codable {
    var bands:[BandJSON]
}



final class OldBand:Equatable {
    
    
    static let insertSQL="insert into tempBands(bandID,name,lastChange,date,stage,shortDesc,longDesc,links,images,genre) values (?,?,?,?,?,?,?,?,?,?)"
    
    var id: Int=0
    var bandID:String
    var name:String
    var lastChange:String
    var date:String
    var stage:String
    var shortDesc:String
    var longDesc:String
    var links:String=""
    var genre:String=""
    var images:String=""
    
    
    var values:[Any] {
        return [bandID,name,lastChange,date,stage,shortDesc,longDesc,links,images,genre]
    }
    
    
    init(data:[MySQLColumn:MySQLData])throws {
        self.id = try data.firstValue(forColumn: "id")?.decode(Int.self) ?? 0
        self.bandID = try data.firstValue(forColumn: "bandID")?.decode(String.self) ?? ""
        self.name = try data.firstValue(forColumn: "name")?.decode(String.self) ?? ""
        self.lastChange = try data.firstValue(forColumn: "lastChange")?.decode(String.self) ?? ""
        self.date = try data.firstValue(forColumn: "date")?.decode(String.self) ?? ""
        self.stage = try data.firstValue(forColumn: "stage")?.decode(String.self) ?? ""
        self.shortDesc = try data.firstValue(forColumn: "shortDesc")?.decode(String.self) ?? ""
        self.longDesc = try data.firstValue(forColumn: "longDesc")?.decode(String.self) ?? ""
        self.links = try data.firstValue(forColumn: "links")?.decode(String.self) ?? ""
        self.genre = try data.firstValue(forColumn: "genre")?.decode(String.self) ?? ""
        self.images = try data.firstValue(forColumn: "images")?.decode(String.self) ?? ""
        
    }
    
    init(band:BandJSON) {
        
        self.bandID = band.band_id
        
        self.name = band.bandname
        self.lastChange = band.termin
        self.date = band.termin
        self.stage = band.buehne
        self.shortDesc = band.kurztext
        self.longDesc = band.beschreibung
        
        self.genre = band.genre.joined(separator: " ")
        
        self.links = band.links.joined(separator: "|")
        
        
        self.images = band.bilder.joined(separator: "|")
        self.images = self.images.replacingOccurrences(of: "/resize-480px", with: "")
        
    }
    
    
    
    static func == (lhs: OldBand, rhs: OldBand) -> Bool {
        return lhs.name == rhs.name  && lhs.date == rhs.date && lhs.stage == rhs.stage && lhs.genre == rhs.genre && lhs.longDesc == rhs.longDesc && lhs.links == rhs.links && lhs.shortDesc == rhs.shortDesc
    }
    
}
