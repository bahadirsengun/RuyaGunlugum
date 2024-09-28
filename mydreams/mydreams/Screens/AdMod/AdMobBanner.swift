//
//  AdMobBanner.swift
//  mydreams
//
//  Created by Bahadır Sengun on 30.08.2024.
//

import SwiftUI
import GoogleMobileAds

struct AdMobBanner: UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> UIViewController {
        return UIViewController()
    }

    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
        let bannerView = GADBannerView(adSize: GADAdSizeBanner) // gerçek id ca-app-pub-6772888339663305/2937535084
        bannerView.adUnitID = "ca-app-pub-6772888339663305/2937535084" // Buraya AdMob reklam birimi ID'nizi ekleyin
        bannerView.rootViewController = uiViewController
        bannerView.load(GADRequest())
        
        bannerView.translatesAutoresizingMaskIntoConstraints = false
        uiViewController.view.addSubview(bannerView)
        
        // Kısıtlamaları ayarla
        NSLayoutConstraint.activate([
            bannerView.bottomAnchor.constraint(equalTo: uiViewController.view.safeAreaLayoutGuide.bottomAnchor),
            bannerView.centerXAnchor.constraint(equalTo: uiViewController.view.centerXAnchor)
        ])
    }
}

