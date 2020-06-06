//
//  UdacityClient.swift
//  onTheMap
//
//  Created by Emad Albarnawi on 31/05/2020.
//  Copyright © 2020 Emad Albarnawi. All rights reserved.
//

import Foundation

class UdacityClient {
    
    struct Auth {
        static var sessionID: String = "";
    }
    
    enum EndPoints {
        static let base: String = "https://onthemap-api.udacity.com/v1/";
        
        case session
        
        var stringValue: String {
            switch self {
            case .session:
                return EndPoints.base + "session";
            }
        }
        enum GetLocations {
            static let base: String = "StudentLocation";
            
            case limit(Int);
            case limitAndSkip(Int, Int);
            case order;
            case uniqueKey(Int);
            case limitAndOrder(Int);
            
            var stringValue: String {
                switch self {
                case .limit(let limit):
                    return EndPoints.base + GetLocations.base + "?limit=\(limit)";
                case .limitAndSkip(let limit, let skip):
                    return EndPoints.base + GetLocations.base + "?limit=\(limit)" + "&skip=\(skip)";
                case .order:
                    return EndPoints.base + GetLocations.base + "?order=-updatedAt";
                case .uniqueKey(let uniqueKey):
                    return EndPoints.base + GetLocations.base + "?uniqueKey=\(uniqueKey)";
                case let .limitAndOrder(limit):
                    return EndPoints.base + GetLocations.base + "?limit=\(limit)" + "&order=-updatedAt";
                }
            }
            var url: URL {
                return URL(string: stringValue)!;
            }
        }
        
        var url: URL {
            return URL(string: stringValue)!;
        }
    }
    
    static func taskForGETRequest<ResponseType: Decodable>(url: URL, responseType: ResponseType.Type, completion: @escaping (ResponseType?, Error?) -> Void) -> URLSessionDataTask {
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data else {
                DispatchQueue.main.async {
                    completion(nil, error)
                }
                return
            }
            let decoder = JSONDecoder()
            do {
                let responseObject = try decoder.decode(ResponseType.self, from: data)
                
                DispatchQueue.main.async {
                    completion(responseObject, nil)
                }
            } catch {
                do {
                    
                    let errorResponse = try decoder.decode(ErrorResponse.self, from: data) as Error
                    DispatchQueue.main.async {
                        completion(nil, errorResponse)
                    }
                } catch {
                    DispatchQueue.main.async {
                        completion(nil, error)
                    }
                }
            }
        }
        task.resume()
        
        return task
    }
    class func taskForPOSTRequest<RequestType: Encodable, ResponseType: Decodable>(url: URL, responseType: ResponseType.Type, body: RequestType, dataLogic: @escaping ((Data?) -> Data?), completion: @escaping (ResponseType?, Error?) -> Void) {
        var request = URLRequest(url: url)
        request.httpMethod = "POST";
        request.httpBody = try! JSONEncoder().encode(body)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = dataLogic(data) else {
                DispatchQueue.main.async {
                    completion(nil, error)
                }
                return
            }
            let decoder = JSONDecoder()
            do {
                let responseObject = try decoder.decode(ResponseType.self, from: data)  
                DispatchQueue.main.async {
                    completion(responseObject, nil)
                }
            } catch {
                do {
                    let errorResponse = try decoder.decode(ErrorResponse.self, from: data) as Error
                    DispatchQueue.main.async {
                        completion(nil, errorResponse)
                    }
                } catch {
                    DispatchQueue.main.async {
                        completion(nil, error)
                    }
                }
            }
        }
        task.resume()
    }
    static func validateUser(email: String, password: String, completion: @escaping (Bool, Error?) -> Void){
        
        let loginBody = Udacity(udacity: LoginBodyRequest(username: email, password: password));
        taskForPOSTRequest(url: EndPoints.session.url, responseType: LoginResponse.self, body: loginBody, dataLogic: taskForPostRequestWithSubdata(data:)) { (response, error) in
            guard let response = response else {
                completion(false, error);
                return;
            }
            completion(true, nil);
        }
    }
    static func getStudentLocations(urlFormat: UdacityClient.EndPoints.GetLocations, completion: @escaping (Bool, Error?) -> Void){
        let url: URL;
        switch urlFormat {
        case .limit(let limit):
            url = UdacityClient.EndPoints.GetLocations.limit(limit).url;
        case let .limitAndSkip(limit, skip):
            url = UdacityClient.EndPoints.GetLocations.limitAndSkip(limit, skip).url;
        case .order:
            url = UdacityClient.EndPoints.GetLocations.order.url;
        case .uniqueKey(let uniqueKey):
            url = UdacityClient.EndPoints.GetLocations.uniqueKey(uniqueKey).url;
        case let .limitAndOrder(limit):
            url = UdacityClient.EndPoints.GetLocations.limitAndOrder(limit).url;
        }
        taskForGETRequest(url: url, responseType: GetStudentLocationResponse.self) { (response, error) in
            guard let response = response else {
                completion(false, error);
                return;
            }
            Locations.studentLocations = response.results;
            completion(true, nil);
        }
    }
    
    
    static func deleteSession(completion: @escaping (Bool, Error?) -> Void){
        var request = URLRequest(url: EndPoints.session.url);
        request.httpMethod = "DELETE"
        var xsrfCookie: HTTPCookie? = nil
        let sharedCookieStorage = HTTPCookieStorage.shared
        for cookie in sharedCookieStorage.cookies! {
          if cookie.name == "XSRF-TOKEN" { xsrfCookie = cookie }
        }
        if let xsrfCookie = xsrfCookie {
          request.setValue(xsrfCookie.value, forHTTPHeaderField: "X-XSRF-TOKEN")
        }
        let session = URLSession.shared
        let task = session.dataTask(with: request) { data, response, error in
          if error != nil { // Handle error…
              return
          }
//          let range = Range(5..<data!.count)
          let newData = data?.subdata(in: 5..<data!.count) /* subset response data! */
            
            let encoder = JSONEncoder()
            do {
                let response = try encoder.encode(newData);
                DispatchQueue.main.async {
                completion(true, nil);
                }
            } catch {
                let decoder = JSONDecoder();
                do {
                    let errorResponse = try decoder.decode(ErrorResponse.self, from: newData!) as Error
                    DispatchQueue.main.async {
                        completion(false, errorResponse)
                    }
                } catch {
                    DispatchQueue.main.async {
                        completion(false, error)
                    }
                }
            }
        }
        task.resume()
    }
    static func taskForPostRequestWithSubdata(data: Data?) -> Data?{
            return data?.subdata(in: 5..<data!.count)
        
        
    }
    static func taskForPostRequestWithoutSubdata(data: Data?) -> Data? {
        return data;
    }
    static func postStudentLocation(studentLocation: StudentLocation, completion: @escaping (Bool, Error?) -> Void){
        taskForPOSTRequest(url: URL(string: EndPoints.base + EndPoints.GetLocations.base)!, responseType: PostStudentLocationResponse.self, body: studentLocation, dataLogic: taskForPostRequestWithoutSubdata(data:)) { (response, error) in
            guard let response = response else {
                completion(false, error);
                return;
            }
            completion(true, nil);
        }
    }
    
}
