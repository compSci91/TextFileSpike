import UIKit
import GoogleSignIn
import GoogleAPIClientForREST
import GTMSessionFetcher

class ViewController: UIViewController , GIDSignInDelegate, GIDSignInUIDelegate {
    let googleSignInButton:UIButton = UIButton(frame: CGRect(x: 500, y: 500, width: 200, height: 100))
    let googleDriveService = GTLRDriveService()
    var googleUser: GIDGoogleUser?
    
    override func viewDidLoad() {
        super.viewDidLoad()
      
     
        /***** Configure Google Sign In *****/
      
        GIDSignIn.sharedInstance()?.delegate = self
        
        // GIDSignIn.sharedInstance()?.signIn() will throw an exception if not set.
        GIDSignIn.sharedInstance()?.uiDelegate = self
        
        /*
         specify the access scope on the GIDSignIn singleton object that manages the OAuth authentication and authorization flow
         Adding the kGTLRAuthScopeDriveFile scope will ask the user to allow full Google Drive access (read and write) to your app during the OAuth flow.
 
         */
        GIDSignIn.sharedInstance()?.scopes =
            [kGTLRAuthScopeDrive]
      
        // Attempt to renew a previously authenticated session without forcing the
        // user to go through the OAuth authentication flow.
        // Will notify GIDSignInDelegate of results via sign(_:didSignInFor:withError:)
        GIDSignIn.sharedInstance()?.signInSilently()
       
        googleSignInButton.backgroundColor = .blue
        googleSignInButton.setTitle("Google Sign In", for: .normal)

        view.addSubview(googleSignInButton)
        googleSignInButton.addTarget(self, action: #selector(onGoogleSignInButtonTap), for: .touchUpInside)
        


        
        // Do any additional setup after loading the view.
        
//        let url = URL(string: "http://theswiftguy.com/wp-content/uploads/2019/10/textFile.txt")!
//
//        let task = URLSession.shared.downloadTask(with: url)  {(urlresponse, response, error) in
//
//            guard let originalUrl = urlresponse else {return}
//
//            do {
//                //get path to directory
//                let path = try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
//
//                //giving name to file
//                let newUrl = path.appendingPathComponent("myTextFile")
//                debugPrint("New Url: ", newUrl)
//
//                //Move file from old to new url
//                try FileManager.default.moveItem(at: originalUrl, to: newUrl)
//            } catch {
//                print(error.localizedDescription)
//                return
//            }
//        }
//
//        task.resume()
        
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
         
         */
        
//        let bundleID = Bundle.main.bundleIdentifier
//        debugPrint("Bundle Identifier: ", bundleID)
   
        // Start Google's OAuth authentication flow
       // GIDSignIn.sharedInstance()?.signIn()
        
        
        
        
        
    
    }
    
    @objc private func onGoogleSignInButtonTap() {
            GIDSignIn.sharedInstance()?.signIn()
    }

    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
            // A nil error indicates a successful login
        // A nil error indicates a successful login
              if error == nil {
                  // Include authorization headers/values with each Drive API request.
                  self.googleDriveService.authorizer = user.authentication.fetcherAuthorizer()
                  self.googleUser = user
              } else {
                  self.googleDriveService.authorizer = nil
                  self.googleUser = nil
              }
        
        
        
        
        googleSignInButton.isHidden = error == nil
    }
}

