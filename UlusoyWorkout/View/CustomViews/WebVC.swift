//
//  WebView.swift
//  UlusoyWorkout
//
//  Created by Mert Ziya on 1.03.2025.
//

import UIKit
import WebKit

class WebVC: UIViewController {
    
    private var webView: WKWebView!
    let webURL: String
    
    // Custom initializer to receive the URL
    init(webURL: String) {
        self.webURL = webURL
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        loadURL()
    }
    
    private func setupUI() {
        view.backgroundColor = .white
        
        // Wrapper View (Top Bar)
        let wrapperView = UIView()
        wrapperView.backgroundColor = .tabbar
        wrapperView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(wrapperView)
        
        // Close Button (Xmark)
        let closeButton = UIButton(type: .system)
        let closeImage = UIImage(systemName: "chevron.left")
        closeButton.setImage(closeImage, for: .normal)
        closeButton.tintColor = .white
        closeButton.addTarget(self, action: #selector(closeTapped), for: .touchUpInside)
        closeButton.translatesAutoresizingMaskIntoConstraints = false
        wrapperView.addSubview(closeButton)
        
        // WebView
        webView = WKWebView()
        webView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(webView)
        
        // Auto Layout Constraints
        NSLayoutConstraint.activate([
            // Wrapper View Constraints
            wrapperView.topAnchor.constraint(equalTo: view.topAnchor),
            wrapperView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            wrapperView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            wrapperView.heightAnchor.constraint(equalToConstant: 100),
            
            // Close Button Constraints
            closeButton.leadingAnchor.constraint(equalTo: wrapperView.leadingAnchor, constant: 16),
            closeButton.bottomAnchor.constraint(equalTo: wrapperView.bottomAnchor, constant: -16),
            closeButton.widthAnchor.constraint(equalToConstant: 30),
            closeButton.heightAnchor.constraint(equalToConstant: 30),
            
            // WebView Constraints
            webView.topAnchor.constraint(equalTo: wrapperView.bottomAnchor),
            webView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            webView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            webView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    private func loadURL() {
        guard let url = URL(string: webURL) else {
            print("Invalid URL: \(webURL)")
            return
        }
        let request = URLRequest(url: url)
        webView.load(request)
    }
    
    @objc private func closeTapped() {
        navigationController?.popViewController(animated: true)
    }
}
