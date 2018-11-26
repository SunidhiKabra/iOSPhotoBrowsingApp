//
//  eventStruct.swift
//  FirebaseInClass01
//
//  Created by Kabra, Sunidhi on 11/21/18.
//  Copyright © 2018 UNC Charlotte. All rights reserved.
//

import Foundation

struct eventStruct {
    let timeStamp: String
    let url: URL
    
    init(timeStamp: String, url: URL) {
        self.timeStamp = timeStamp;
        self.url = url;
    }
}
