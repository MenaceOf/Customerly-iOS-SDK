//
//  CyConfig.swift
//  Customerly
//
//  Created by Paolo Musolino on 09/10/16.
//
//

import Foundation

let API_BASE_URL = "http://tracking.customerly.io"

// The domain used for creating all Customerly errors.
let cy_domain = "io.customerly.CustomerlySDK"

// Extra device and app info
let cy_app_version = "\(Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") ?? "")" //TODO: App end developer
let cy_app_build = Bundle.main.object(forInfoDictionaryKey:kCFBundleVersionKey as String) //TODO: App end developer
let cy_device = UIDevice.current.model
let cy_os = UIDevice.current.systemName
let cy_os_version = UIDevice.current.systemVersion
let cy_app_name = "Customerly iOS SDK" //TODO: App end developer
let cy_sdk_version = "\(1)"
let cy_api_version = "\(1)"
let cy_socket_version = "\(1)"

//Default parameters
let base_color_template = UIColor(hexString: "4397e6") //Air Force Blue
var user_color_template: UIColor?

//Images
func adminImageURL(id: Int?, pxSize: Int) -> URL{
    if let admin_id = id{
        return URL(string: "http://pictures.customerly.io/accounts/\(admin_id)/\(pxSize)")!
    }
    return URL(string: "http://pictures.customerly.io/accounts/-/\(pxSize)")!
    }

func userImageURL(id: String?, pxSize: Int) -> URL{
    if let user_id = id{
        return URL(string: "http://pictures.customerly.io/users/\(user_id)/\(pxSize)")!
    }
    return URL(string: "http://pictures.customerly.io/users/-/\(pxSize)")!
}
