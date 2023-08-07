//
//  RequestData.swift
//  Avtomobilka
//
//  Created by Steven Kirke on 02.08.2023.
//

import Foundation


class RequestData {
    
    let task = URLSession.shared
    
    func getDataWithHeader(url: String, returnData: @escaping (Data?, String, String) -> Void) {
        guard let url = URL(string: url) else {
            returnData(nil, "Convert url.", "")
            return
        }
        let request = URLRequest(url: url)
        let dataTask = task.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                var currentTotalPage: String = ""
                if error != nil {
                    returnData(nil, "Request data.", "")
                    print("Error 1")
                    return
                }
                if let httpResponse = response as? HTTPURLResponse {
                     guard let totalPage = httpResponse.allHeaderFields["Total-Pages"] as? String  else {
                         print("Error 2")
                         return
                     }
                    currentTotalPage = totalPage
                    print("totalPage \(totalPage)")
                }

                guard let currentData = data else {
                    print("Error 3")
                    returnData(nil, "Response data." , "")
                    return
                }
                returnData(currentData, "", currentTotalPage)
            }
        }
        dataTask.resume()
    }
    
    func getData(url: String, returnData: @escaping (Data?, String) -> Void) {
        guard let url = URL(string: url) else {
            returnData(nil, "Convert url.")
            return
        }
        let request = URLRequest(url: url)
        let dataTask = task.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                if error != nil {
                    returnData(nil, "Request data.")
                    return
                }
                guard let currentData = data else {
                    returnData(nil, "Response data.")
                    return
                }
                returnData(currentData, "")
            }
        }
        dataTask.resume()
    }
}


private func assamblyURL(url: String, key: String, value: String) -> URLRequest? {
    guard var currentUrl = URL(string: url) else {
        print("Error convert URL")
        return nil
    }
    currentUrl.append(queryItems: [URLQueryItem.init(name: key, value: value)])
    var request = URLRequest(url: currentUrl)
    request.httpMethod = "GET"
    return request
}
