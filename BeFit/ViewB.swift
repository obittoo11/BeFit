//
//  ViewB.swift
//  BeFit
//
//  Created by Sahib Anand on 05/03/23.
//

import SwiftUI

struct ViewB: View {
    var body: some View {
        ZStack {
            Color.blue
                .ignoresSafeArea()
            
            Image(systemName: "fork.knife")
                .foregroundColor(Color.white)
                .font(.system(size: 100))
        }
    }
}

struct ViewB_Previews: PreviewProvider {
    static var previews: some View {
        ViewB()
    }
}
