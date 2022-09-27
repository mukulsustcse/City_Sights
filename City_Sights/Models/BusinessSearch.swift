//
//  BusinessSearch.swift
//  City_Sights
//
//  Created by M. A. Alim Mukul on 27.09.22.
//

import Foundation

struct BusinessSearch: Decodable {
    
    var businesses = [Business]()
    var total = 0
    var region = Region()
}

struct Region: Decodable {
    
    var center = Coordinate()
}
