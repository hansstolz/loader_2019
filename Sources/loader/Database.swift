//
//  Database.swift
//  loader
//
//  Created by go on 09.05.19.
//

import Foundation
import MySQL

class Database {
    let client:MySQLConnection?
    
    init?() {
        do {
            client = try MySQLConnection.connect()
        } catch {
            print(error)
            client=nil
        }
    }
    
    
    func loadImages() {
        let loader=ImageLoader()
        let bands = getBands()
        loader.load(bands: bands)
    }
    
    
    func buildRelations() {
        let bands = getBands()
        
        let encoder=JSONEncoder()
        
        
        for band in bands {
           
            let filter = bands.filter { (b) -> Bool in
                if let r1=band.related_1, b.Bandname.starts(with: r1.prefix(9)) {
                    return true
                }
                if let r2=band.related_2, b.Bandname.starts(with: r2.prefix(9)) {
                    return true
                }
                if let r3=band.related_3, b.Bandname.starts(with: r3.prefix(9)) {
                    return true
                }
                
                return false
            }
            
            band.related=filter.map{ $0.id!}
            
           
            
            do {
                let value=try encoder.encode(band.related)
                
                let _ = try  client?.update(Band.self)
                    .set(["related": String(decoding: value, as: UTF8.self)])
                    .where(\Band.id, .equal, band.id)
                    .run()
                    .wait()
                
            } catch let ex {
                print(ex)
            }
            
        }
    }
    
    func saveBands(_ bands:[Band]) {
        do {
        let _ =  try client?.simpleQuery("truncate table band").wait()
        
        for band in bands {
            
           let _ = try  client?.insert(into: Band.self).value(band).run().wait()
        
          
            
        }
        } catch let ex {print(ex)}
    }
    
    
    
    private func getBands() ->[Band] {
        do {
        if let bands = try client?.select()
            .all()
            .from(Band.self)
            .orderBy(\Band.id)
            .all(decoding: Band.self).wait() {
        return bands
        }
        } catch let ex {
            print(ex)
        }
        
        return []
    }

    
    
    deinit {
        client?.close()
    }
    
}




