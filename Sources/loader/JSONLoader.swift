//
//  JSONLoader.swift
//  loader
//
//  Created by go on 09.05.19.
//

import Foundation
import HTTP


class JSONLoader {
    
    func load()->[Band] {
        do {
            if let data = try getData("https://share.ninoxdb.de/fpn508x9qsxbec6yxsuphyga4c2sewt3fwbf") {
                let decoder = JSONDecoder()
                let bands = try decoder.decode([Band].self, from: data)
                return bands
                
            }
        } catch let ex {
            print(ex)
        }
        return []
    }
    
    private func getData(_ string: String) throws -> Data? {
        guard let url = URL(string: string) else {
            throw HTTPError(identifier: "parseURL", reason: "Could not parse URL: \(string)")
        }
        let scheme: HTTPScheme = url.scheme == "https" ? .https : .http
        let worker = MultiThreadedEventLoopGroup(numberOfThreads: 1)
        let res = try HTTPClient.connect(scheme: scheme, hostname: url.host ?? "", on: worker).flatMap(to: HTTPResponse.self) { client in
            var comps =  URLComponents()
            comps.path = url.path.isEmpty ? "/" : url.path
            comps.query = url.query
            let req = HTTPRequest(method: .GET, url: comps.url ?? .root)
            return client.send(req)
            }.wait()
        
        return res.body.data
        
    }
    
    
    
}
