import Foundation
import AuthenticationServices

public class WebAuthenticationSession: NSObject {

    public var authenticationSession: ASWebAuthenticationSession?

    func start(
        url: URL,
        context: ASWebAuthenticationPresentationContextProviding,
        sessionDidComplete: @escaping (URL?, Error?) -> Void,
        sessionDidCancel: @escaping () -> Void
    ) {
        self.authenticationSession = ASWebAuthenticationSession(
            url: url,
            callbackURLScheme: PopupBridgeConstants.callbackURLScheme
        ) { url, error in
            if let error = error as? NSError, error.code == ASWebAuthenticationSessionError.canceledLogin.rawValue {
                sessionDidCancel()
            } else {
                sessionDidComplete(url, error)
            }
        }

        authenticationSession?.prefersEphemeralWebBrowserSession = false
        authenticationSession?.presentationContextProvider = context

        authenticationSession?.start()
    }
}
