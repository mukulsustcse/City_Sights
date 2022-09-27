//
//  City_SightsApp.swift
//  City_Sights
//
//  Created by M. A. Alim Mukul on 20.09.22.
//

import SwiftUI

@main
struct CitySightsApp: App {
    var body: some Scene {
        WindowGroup {
            LaunchView()
                .environmentObject(ContentModel())
        }
    }
}
