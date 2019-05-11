//
//  MySQLConnection.swift
//  CommandLineTool
//
//  Created by go on 12.06.18.
//

import MySQL


extension MySQLConnection {
    /// Creates a test event loop and psql client.
    static func connect()throws -> MySQLConnection {
            let group = MultiThreadedEventLoopGroup(numberOfThreads: 1)
        
           // let database = MySQLDatabaseConfig(hostname: "localhost", port: 3306,  username: "root", password: "fermat", database: "uud")
        
        let database = MySQLDatabaseConfig(hostname: "46.101.243.221", port: 3306,  username: "root", password: "Galois271", database: "uud")
        
        let client = try MySQLConnection.connect(config: database,on: group).wait()
        
        
        return client
    }
    
   
}
