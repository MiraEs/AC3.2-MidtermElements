//
//  Element.swift
//  AC3.2-MidtermElements
//
//  Created by Ilmira Estil on 12/8/16.
//  Copyright © 2016 C4Q. All rights reserved.
//

import Foundation

internal enum jsonError: Error {
    case jsonData(json: Any)
}
internal enum Parsing: Error {
    case elementProperties(dict: [String:AnyObject])
    
}

class Element {
    internal let number: Int
    internal let weight: Double
    internal let name: String
    internal let symbol: String
    internal let meltingPoint: Int
    internal let boilingPoint: Int
    
    init(number: Int, weight: Double, name: String, symbol: String, meltingPoint: Int, boilingPoint: Int) {
        self.number = number
        self.weight = weight
        self.name = name
        self.symbol = symbol
        self.meltingPoint = meltingPoint
        self.boilingPoint = boilingPoint
    }
    
    static func buildElement(data: Data) -> [Element]? {
        var elements = [Element]()
        do {
            let jsonData = try JSONSerialization.jsonObject(with: data, options: [])
            guard let jsonDict = jsonData as? [[String: AnyObject]] else {
                throw jsonError.jsonData(json: jsonData)
            }
            
            for dict in jsonDict {
                guard let number = dict["number"] as? Int,
                    let weight = dict["weight"] as? Double,
                    let name = dict["name"] as? String,
                    let symbol = dict["symbol"] as? String,
                    let meltingPoint = dict["melting_c"] as? Int,
                    let boilingPoint = dict["boiling_c"] as? Int else {
                        throw Parsing.elementProperties(dict: dict)
                }

                
                let elementProperties = Element(number: number, weight: weight, name: name, symbol: symbol, meltingPoint: meltingPoint, boilingPoint: boilingPoint)
                elements.append(elementProperties)
            }
        } catch let jsonError.jsonData(json: jsonData) {
            print("Error w/ jsonData: \(jsonData)")
        } catch let Parsing.elementProperties(dict: dict) {
            print("Error w/ parsing element props: \(dict)")
        } catch {
            print("Unknown error: \(error)")
        }
        return elements
    }
 
}
