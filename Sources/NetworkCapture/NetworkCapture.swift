//
//  NetworkCapture.swift
//  test
//
//  Created by Pankaj Kaushik on 04/05/23.
//

import Foundation

class NetworkCapture {

    static func startCapturing() {
        URLProtocol.registerClass(NetworkCaptureURLProtocol.self)
    }

    static func stopCapturing() {
        URLProtocol.unregisterClass(NetworkCaptureURLProtocol.self)
    }
}

class NetworkCaptureURLProtocol: URLProtocol {
    
    override class func canInit(with request: URLRequest) -> Bool {
        // Return true for all requests so that we can capture them
        return true
    }

    override class func canonicalRequest(for request: URLRequest) -> URLRequest {
        return request
    }

    override func startLoading() {
        // Log the request
        logRequest(request)

        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            // Log the response
            self.logResponse(response, data: data, error: error)

            // Pass the response along to the client
            if let data = data {
                self.client?.urlProtocol(self, didLoad: data)
            }
            if let response = response {
                self.client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .allowed)
            }
            self.client?.urlProtocolDidFinishLoading(self)
        }
        task.resume()
    }

    override func stopLoading() {
        // Not needed
    }

    private func logRequest(_ request: URLRequest) {
        if let url = request.url?.absoluteString, let method = request.httpMethod {
            print("Request******: \(method) \(url)")
            if let headers = request.allHTTPHeaderFields {
                print("Headers*****: \(headers)")
            }
            if let body = request.httpBody {
                if let bodyString = String(data: body, encoding: .utf8) {
                    print("Body*****: \(bodyString)")
                }
            }
        }
    }

    private func logResponse(_ response: URLResponse?, data: Data?, error: Error?) {
        if let url = response?.url?.absoluteString, let statusCode = (response as? HTTPURLResponse)?.statusCode {
            print("Response********: \(statusCode) \(url)")
            if let headers = (response as? HTTPURLResponse)?.allHeaderFields {
                print("Headers: \(headers)")
            }
            if let data = data, let bodyString = String(data: data, encoding: .utf8) {
                print("Body*****: \(bodyString)")
            }
            if let error = error {
                print("Error*****: \(error.localizedDescription)")
            }
        }
    }
}
