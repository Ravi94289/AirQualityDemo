//
//  ResponseDataProvider.swift
//  AirQuality
//
//  Created by Ravi Bhratkumar Amalseda on 29/01/22.
//

import Foundation
import Starscream

protocol RespDataProviderDelegate {
    func didReceive(response: Result<[AirQualityRespData], Error>)
}

class DataProvider {
    var isConnected: Bool = false
    var delegate: RespDataProviderDelegate?
    var wbSocket: WebSocket? = {
        guard let url = URL(string: Host.url) else {
            print("can not create URL from: \(Host.url)")
            return nil
        }
        var request = URLRequest(url: url)
        request.timeoutInterval = 5
        
        var socket = WebSocket(request: request)
        return socket
    }()
    
    func connetSocket() {
        self.wbSocket?.delegate = self
        self.wbSocket?.connect()
    }
    
    func disConnetSocket() {
        self.wbSocket?.disconnect()
    }
    
    deinit {
        self.wbSocket?.disconnect()
        self.wbSocket = nil
    }
    
}

extension DataProvider: WebSocketDelegate {
    
    func didReceive(event: WebSocketEvent, client: WebSocket) {
        switch event {
            case .connected(let headers):
                isConnected = true
                print("websocket is connected: \(headers)")
            case .disconnected(let reason, let code):
                isConnected = false
                print("websocket is disconnected: \(reason) with code: \(code)")
            case .text(let string):
                handleText(text: string)
            case .binary(let data):
                print("Received data: \(data.count)")
            case .ping(_):
                break
            case .pong(_):
                break
            case .viabilityChanged(_):
                break
            case .reconnectSuggested(_):
                break
            case .cancelled:
                isConnected = false
            case .error(let error):
                isConnected = false
                handleError(error: error)
            }
    }
    
    private func handleText(text: String) {
        let jsonData = Data(text.utf8)
        let decoder = JSONDecoder()
        do {
            let resArray = try decoder.decode([AirQualityRespData].self, from: jsonData)
            self.delegate?.didReceive(response: .success(resArray))
            
        } catch {
            print(error.localizedDescription)
        }
    }
    
    private func handleError(error: Error?) {
        if let e = error {
            self.delegate?.didReceive(response: .failure(e))
        }
    }
}
