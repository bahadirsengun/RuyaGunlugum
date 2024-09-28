//
//  ProfileBanner.swift
//  mydreams
//
//  Created by Bahadır Sengun on 30.08.2024.
//

import SwiftUI
import GoogleMobileAds


struct ProfileBanner: UIViewRepresentable {
    func makeUIView(context: Context) -> GADBannerView {
        let banner = GADBannerView(adSize: GADAdSizeBanner) //gerçe id ca-app-pub-6772888339663305/5937837592
        banner.adUnitID = "ca-app-pub-3940256099942544/2435281174" // Test reklam ID'si
        banner.rootViewController = UIApplication.shared.windows.first?.rootViewController
        banner.load(GADRequest())
        return banner
    }
    
    func updateUIView(_ uiView: GADBannerView, context: Context) {
    }
}
