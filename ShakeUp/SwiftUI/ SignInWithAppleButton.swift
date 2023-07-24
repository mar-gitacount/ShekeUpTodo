//
//   SignInWithAppleButton.swift
//  ShakeUp
//
//  Created by 市川マサル on 2023/05/23.
//  Copyright © 2023 hal-cha-n. All rights reserved.
//

import SwiftUI
import AuthenticationServices

struct SignInWithAppleButton: UIViewRepresentable {
    typealias UIViewType = ASAuthorizationAppleIDButton

    func makeUIView(context: Context) -> ASAuthorizationAppleIDButton {
        return ASAuthorizationAppleIDButton(type: .signIn, style: .black)
    }

    func updateUIView(_ uiView: ASAuthorizationAppleIDButton, context: Context) {}
}


struct _SignInWithAppleButton: View {
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}

struct _SignInWithAppleButton_Previews: PreviewProvider {
    static var previews: some View {
        _SignInWithAppleButton()
    }
}
