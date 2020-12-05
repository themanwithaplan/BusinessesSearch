//
//  BusinessesModel.swift
//  BusinessesSearch
//
//  Created by Sharaf Nazaar on 12/4/20.
//

import Foundation

// MARK: - BusinessesModel
class BusinessesModel: Codable {
    let businesses: [Business]
    let total: Int
    let region: Region

    init(businesses: [Business], total: Int, region: Region) {
        self.businesses = businesses
        self.total = total
        self.region = region
    }
}

// MARK: - Business
class Business: Codable {
    let id, alias, name: String
    let imageurl: String
    let isClosed: Bool
    let url: String
    let reviewCount: Int
    let categories: [Category]
    let rating: Double
    let coordinates: Coordinates
    let transactions: [String]
    let price: String?
    let location: Location
    let phone, displayPhone: String
    let distance: Double

    enum CodingKeys: String, CodingKey {
        case id, alias, name
        case imageurl = "image_url"
        case isClosed = "is_closed"
        case url
        case reviewCount = "review_count"
        case categories, rating, coordinates, transactions, price, location, phone
        case displayPhone = "display_phone"
        case distance
    }

    init(id: String, alias: String, name: String, imageurl: String, isClosed: Bool, url: String, reviewCount: Int, categories: [Category], rating: Double, coordinates: Coordinates, transactions: [String], price: String?, location: Location, phone: String, displayPhone: String, distance: Double) {
        self.id = id
        self.alias = alias
        self.name = name
        self.imageurl = imageurl
        self.isClosed = isClosed
        self.url = url
        self.reviewCount = reviewCount
        self.categories = categories
        self.rating = rating
        self.coordinates = coordinates
        self.transactions = transactions
        self.price = price
        self.location = location
        self.phone = phone
        self.displayPhone = displayPhone
        self.distance = distance
    }
}

// MARK: - Category
class Category: Codable {
    let alias, title: String

    init(alias: String, title: String) {
        self.alias = alias
        self.title = title
    }
}

// MARK: - Coordinates
class Coordinates: Codable {
    let latitude, longitude: Double

    init(latitude: Double, longitude: Double) {
        self.latitude = latitude
        self.longitude = longitude
    }
}

// MARK: - Location
class Location: Codable {
    let address1: String?
    let address2, address3: String?
    let city, zipCode, country, state: String
    let displayAddress: [String]

    enum CodingKeys: String, CodingKey {
        case address1, address2, address3, city
        case zipCode = "zip_code"
        case country, state
        case displayAddress = "display_address"
    }

    init(address1: String?, address2: String?, address3: String?, city: String, zipCode: String, country: String, state: String, displayAddress: [String]) {
        self.address1 = address1
        self.address2 = address2
        self.address3 = address3
        self.city = city
        self.zipCode = zipCode
        self.country = country
        self.state = state
        self.displayAddress = displayAddress
    }
}

// MARK: - Region
class Region: Codable {
    let center: Coordinates

    init(center: Coordinates) {
        self.center = center
    }
}
