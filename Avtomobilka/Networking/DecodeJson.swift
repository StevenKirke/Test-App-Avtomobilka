//
//  DecodeJson.swift
//  Avtomobilka
//
//  Created by Steven Kirke on 02.08.2023.
//

import Foundation


class DecodeJson {
    
    func decodeJSON<T: Decodable>(data: Data, model: T, returnJSON: @escaping (T?, String) -> Void)  {
        DispatchQueue.main.async {
            do {
                let decodedUsers = try JSONDecoder().decode(T.self, from: data)
                return returnJSON(decodedUsers, "")
            } catch let error {
                print("Error  \(error)")
                return returnJSON(nil, "Error decode JSON.")
            }
        }
    }
    
    
    func encodeJSON<T: Encodable>(models: T, returnData: @escaping (Data?, String) -> Void) {
        DispatchQueue.main.async {
            do {
                let data = try JSONEncoder().encode(models)
                return returnData(data, "")
            } catch {
                return returnData(nil, "Error decode in data.")
            }
        }
    }
}
