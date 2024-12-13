//
//  APIEndpoints.swift
//  Cuisinary
//
//  Created by Myat Thu Ko on 12/13/24.
//

struct API {
    static let baseURL = "https://d3jbb8n5wk0qxi.cloudfront.net"

    enum Endpoint {
        case allRecipes
        case malformedData
        case emptyData

        /// Returns the URL as a `String`
        var urlString: String {
            switch self {
            case .allRecipes:
                return API.buildURLString(path: "/recipes.json")
            case .malformedData:
                return API.buildURLString(path: "/recipes-malformed.json")
            case .emptyData:
                return API.buildURLString(path: "/recipes-empty.json")
            }
        }
    }

    private static func buildURLString(path: String) -> String {
        return "\(baseURL)\(path)"
    }
}

