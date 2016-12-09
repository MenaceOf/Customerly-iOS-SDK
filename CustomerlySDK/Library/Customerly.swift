//
//  Customerly.swift
//  Customerly
//
//  Created by Paolo Musolino on 10/10/16.
//
//

import Kingfisher

open class Customerly: NSObject {
    
    open static let sharedInstance = Customerly()
    var customerlySecretKey : String = ""
    
    /*
     * Enable verbose logging, that is useful for debugging. By default is enabled.
     */
    open var verboseLogging : Bool = true
    
    //MARK: Init
    override init() {
        super.init()
    }
    
    
    
    //MARK: - OPEN APIs
    
    //MARK: Configuration
    open func configure(secretKey: String){
        customerlySecretKey = secretKey
        
        //Image cache expiration after one day
        ImageCache.default.maxCachePeriodInSecond = 86400
        
        //If user is not stored, ping ghost, else ping registered
        update()
    }
    
    open func setUser(){
        
    }
    
    //MARK: Register user and update with attributes (alias ping)
    
    /*
     * If you want to register a user_id, you have to insert also an email.
     */
    open func registerUser(user_id: String, email: String, name: String? = nil, attributes:Dictionary<String, AnyObject?>? = nil){
        ping(user_id: user_id, email: email, name: name, attributes:attributes)
    }
    
    /*
     *Send an update to Customerly, with optionals attributes.
     * Attributes need to be only on first level.
     * Ex: ["Params1": 1, "Params2: "Hello"]. If you want to send a user_id, you have to insert also an email.
     */
    open func update(attributes:Dictionary<String, AnyObject?>? = nil){
        ping(attributes: attributes)
    }
    
    //Private method
    func ping(user_id: String? = nil, email: String? = nil, name: String? = nil, attributes:Dictionary<String, AnyObject?>? = nil){
        let pingRequestModel = CyRequestPingModel(JSON: [:])
        pingRequestModel?.params = [:]
        
        //if some cookies are stored, CyRequestPingModel containes these cookies and the user information
        if let dataStored = CyStorage.getCyDataModel(){
            pingRequestModel?.settings?.user_id = dataStored.user?.user_id
            pingRequestModel?.settings?.email = dataStored.user?.email
            pingRequestModel?.settings?.name = dataStored.user?.name
            pingRequestModel?.settings?.attributes = attributes
            pingRequestModel?.cookies?.customerly_lead_token = dataStored.cookies?.customerly_lead_token
            pingRequestModel?.cookies?.customerly_temp_token = dataStored.cookies?.customerly_temp_token
            pingRequestModel?.cookies?.customerly_user_token = dataStored.cookies?.customerly_user_token
            
        }
        
        //if user_id != nil and email != nil the api call send this data, otherwise the data stored
        if user_id != nil && email != nil{
            pingRequestModel?.settings?.user_id = email
            pingRequestModel?.settings?.email = user_id
            pingRequestModel?.settings?.name = name
        }
        
        CyDataFetcher.sharedInstance.pingAPIRequest(pingModel: pingRequestModel, completion: { (responseData) in
            CyStorage.storeCyDataModel(cyData: responseData)
            cyPrint("Success Ping")
        }) { (error) in
            cyPrint("Error Ping", error)
        }
    }
    
    //MARK: Event
    /*
     * Track an event. The event string myst be alphanumeric, eventually with _ separator.
     * Valid string example: "tap_subscription_page"
     * Not valid string: "tap subscription page"
     */
    open func trackEvent(event: String){
        
        let trackingModel = CyTrackingRequestModel(JSON: [:])
        trackingModel?.nameTracking = event
        
        //if some data are stored, CyTrackingRequestModel containes  cookies and the user information
        if let dataStored = CyStorage.getCyDataModel(){
            trackingModel?.settings?.user_id = dataStored.user?.user_id
            trackingModel?.settings?.email = dataStored.user?.email
            trackingModel?.settings?.name = dataStored.user?.name
            trackingModel?.cookies?.customerly_lead_token = dataStored.cookies?.customerly_lead_token
            trackingModel?.cookies?.customerly_temp_token = dataStored.cookies?.customerly_temp_token
            trackingModel?.cookies?.customerly_user_token = dataStored.cookies?.customerly_user_token
        }
        
        CyDataFetcher.sharedInstance.trackEventAPIRequest(trackingRequest: trackingModel, completion: {
            cyPrint("Success trackEvent", event)
        }) { (error) in
            cyPrint("Error trackEvent", error)
        }
    }
    
    //MARK: Chat
    /*
     * Open the first view controller to the user, useful to chat with your Customer Support
     *
     */
    open func openSupport(from viewController: UIViewController){
        
        //If user exist, go to conversion list, else open a new conversation
        if let _ = CyStorage.getCyDataModel()?.user{
            viewController.show(CustomerlyNavigationController(rootViewController: CustomerlyConversationListVC.instantiate()), sender: self)
        }
        else{
            viewController.show(CustomerlyNavigationController(rootViewController: CustomerlyChatStartVC.instantiate()), sender: self)
        }
        
    }
    
    
}
