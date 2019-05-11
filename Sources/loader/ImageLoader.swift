//
//  ImageLoader.swift
//  Async
//
//  Created by go on 10.05.19.
//

import Foundation
import HTTP


class ImageLoader {
    
    func load(bands:[Band]) {
        for band in bands {
            if let imgURL=band.imgURL {
                do {
                    if let data = try getData(imgURL),
                        let image=band.bild1?.replacingOccurrences(of: "/", with: ""),
                        let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
                        let fileURL = dir.appendingPathComponent(image)
                        try data.write(to: fileURL)
                    }
                } catch let exception {
                    print(exception)
                }
            }
        }
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
