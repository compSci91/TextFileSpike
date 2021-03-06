import UIKit
import GoogleSignIn
import GoogleAPIClientForREST
import GTMSessionFetcher

class ViewController: UIViewController, GIDSignInDelegate  {
    let googleSignInButton:UIButton = UIButton(frame: CGRect(x: 500, y: 500, width: 200, height: 100))
    let uploadButton:UIButton = UIButton(frame: CGRect(x: 500, y: 1000, width: 200, height: 100))
    
    let signInButton:GIDSignInButton = GIDSignInButton(frame: CGRect(x: 200, y: 200, width: 200, height: 100))
    let googleDriveService = GTLRDriveService()
    var googleUser: GIDGoogleUser?
    var uploadFolderID: String?
    var number:Int = 0
    let sheetsService = GTLRSheetsService()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        GIDSignIn.sharedInstance().delegate = self
        GIDSignIn.sharedInstance()?.presentingViewController = self
        
        GIDSignIn.sharedInstance()?.scopes.append(kGTLRAuthScopeSheetsSpreadsheets)
        GIDSignIn.sharedInstance()?.scopes =
                   [kGTLRAuthScopeDrive]
//        GIDSignIn.sharedInstance()?.scopes.append(kGTLRAuthScopeSheetsDrive)

        GIDSignIn.sharedInstance()?.restorePreviousSignIn()
        
        view.addSubview(signInButton)
        
//        GIDSignIn.sharedInstance()?.scopes =
//            [kGTLRAuthScopeDrive]
      
        uploadButton.backgroundColor = .blue
        uploadButton.setTitle("Append Google Sheet", for: .normal)
        view.addSubview(uploadButton)
        uploadButton.addTarget(self, action: #selector(onButtonTap), for: .touchUpInside)

        
        
    }
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        if let error = error {
           if (error as NSError).code == GIDSignInErrorCode.hasNoAuthInKeychain.rawValue {
             print("The user has not signed in before or they have since signed out.")
           } else {
             print("\(error.localizedDescription)")
           }
           return
         }
         // Perform any operations on signed in user here.
        
        
        
            // Include authorization headers/values with each Drive API request.
        self.googleDriveService.authorizer = user.authentication.fetcherAuthorizer()
        self.googleUser = user
       
         self.googleUser = user
//         let userId = user.userID                  // For client-side use only!
//         let idToken = user.authentication.idToken // Safe to send to the server
//         let fullName = user.profile.name
//         let givenName = user.profile.givenName
//         let familyName = user.profile.familyName
//         let email = user.profile.email
        
        sheetsService.authorizer = GIDSignIn.sharedInstance()?.currentUser.authentication.fetcherAuthorizer()

        
        debugPrint("*******************************")
        debugPrint("Login was called!")
        debugPrint("*******************************")
    }

    
    
    @objc func onButtonTap(){
        appendToGoogleSheets([["Hello", "World", String(number)]])
    }
    
    
    func appendToGoogleSheets(_ values:[[String]]){
        let spreadsheetId = "1UBW-T5YZ-iDTEi1j0hXaSouodJBEsmZnWaxJSZ9w1_A"
        let range = "Sheet1"
        let valueRange = GTLRSheets_ValueRange.init();
        valueRange.values = values
        number = number + 1
        
        let query = GTLRSheetsQuery_SpreadsheetsValuesAppend.query(withObject: valueRange, spreadsheetId:spreadsheetId, range:range)
        query.valueInputOption = "USER_ENTERED"

        sheetsService.executeQuery(query) { (ticket, any, error) in
            if let error = error {
                print(error)
            }
            print(any)
            print(ticket)
        }

    }
    
    @objc private func onGoogleSignInButtonTap() {
        GIDSignIn.sharedInstance()?.signIn()
    }
     
}


/*
    OAuth Client
    Client ID
 363243949693-k4tk2l5gfuk939l7tig32gjr4k88mf5b.apps.googleusercontent.com
 
 Cutom URLs
 
 https://www.hackingwithswift.com/example-code/system/how-to-make-your-app-open-with-a-custom-url-scheme#:~:text=To%20register%20your%20custom%20URL,open%20that%20last%20disclosure%20indicator.
 
 
 How to Add Native iOS Google Sign In
 https://medium.com/@kgleong/how-to-add-native-ios-google-sign-in-8ef66c09006e
 
 GoogleSignIn ios append to google sheets
 https://stackoverflow.com/questions/52762379/googlesignin-ios-append-to-google-sheets
 
 GoogleSignIn ios append to google sheets
 https://stackoverflow.com/questions/52762379/googlesignin-ios-append-to-google-sheets
 
 Updating specific row in iOS Swift using Google SpreadSheet API
 https://stackoverflow.com/questions/51585042/updating-specific-row-in-ios-swift-using-google-spreadsheet-api
 
 
 Connectiong sheets api in swift
 http://berkolcay.blogspot.com/2018/12/connecting-sheets-ap-in-swift-step-by.html

 Make sure to publish the app!
 
 Uploading Files to Google Drive using the Google iOS SDK
 https://medium.com/@kgleong/uploading-files-to-google-drive-using-the-google-ios-sdk-fcad3e9d6c07
 
 How to Add Native iOS Google Sign In
 https://medium.com/@kgleong/how-to-add-native-ios-google-sign-in-8ef66c09006e
 
 Try Sign-In for iOS
 https://developers.google.com/identity/sign-in/ios/start?ver=swift
 */

