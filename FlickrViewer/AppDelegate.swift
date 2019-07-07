//
//  AppDelegate.swift
//  FlickrViewer
//
//  Created by Eugene Belyakov on 03/07/2019.
//  Copyright © 2019 Ievgen Bieliakov. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        let networkService = NetworkingServiceImpl()
        let api = APIServiceImpl(networkingService: networkService)
        let photoSearchService = PhotoSearchService(api: api)
        let cacheService = CacheServiceImpl()
        let photoDownloadService = PhotoDownloadService(api: api, cache: cacheService)
        
        if let photosViewController = window?.rootViewController as? PhotosViewController {
            photosViewController.photoSearchService = photoSearchService
            photosViewController.photoDownloadService = photoDownloadService
        }
        
        return true
    }
}

