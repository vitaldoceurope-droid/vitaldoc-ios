import SwiftUI
@preconcurrency import WebKit

struct WebView: UIViewRepresentable {
    let urlString: String

    func makeUIView(context: Context) -> WKWebView {
        let config = WKWebViewConfiguration()
        
        // PERMISOS CLAVE PARA VITALCALL
        config.allowsInlineMediaPlayback = true // Permite video dentro de la web sin pantalla completa
        
        
        let webView = WKWebView(frame: .zero, configuration: config)
        
        // Identificador para tu Laravel
        webView.customUserAgent = "Mozilla/5.0 (iPhone; CPU iPhone OS 17_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/17.0 Mobile/15E148 Safari/604.1 VitadocApp"
        
        webView.uiDelegate = context.coordinator // Necesario para permisos de cámara/mic
        
        return webView
    }

    func updateUIView(_ webView: WKWebView, context: Context) {
        if let url = URL(string: urlString) {
            let request = URLRequest(url: url)
            webView.load(request)
        }
    }

    func makeCoordinator() -> Coordinator {
        Coordinator()
    }

    class Coordinator: NSObject, WKUIDelegate {
        // Este bloque permite que la web pida cámara y micrófono en iOS 15 o superior
        @available(iOS 15.0, *)
        func webView(_ webView: WKWebView, requestMediaCapturePermissionFor origin: WKSecurityOrigin, initiatedByFrame frame: WKFrameInfo, type: WKMediaCaptureType, decisionHandler: @escaping (WKPermissionDecision) -> Void) {
            decisionHandler(.grant) // Esto le dice al WebView que acepte si el usuario ya dio permiso a la App
        }
    }
}

struct ContentView: View {
    let miURL = "https://www.vitaldoc.org" // <--- Pon tu URL real

    var body: some View {
        ZStack {
            Color.white.edgesIgnoringSafeArea(.all)
            WebView(urlString: miURL)
                .edgesIgnoringSafeArea(.all)
        }
    }
}
