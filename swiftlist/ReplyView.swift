//
//  ReplyView.swift
//  swiftlist
//
//  Created by Dagg on 7/10/22.
//

import SwiftUI

struct ReplyView: View {
    @State var replies: Comments?
    let nestLimit: Int = 3
    @State var nestCount: Int = 0
    
    var body: some View {
        if(replies != nil && nestCount != nestLimit) {
            ForEach(replies?.comment ?? []) { reply in
                switch (reply.author) {
                case "":
                    EmptyView()
                default:
                    HStack {
                        Divider().padding(.vertical,0)
                        VStack {
                            HStack {
                                Text("/u/\(reply.author!)").fontWeight(.bold)
                                if (reply.op!) {
                                    Text("OP").fontWeight(.bold).foregroundColor(.accentColor)
                                }
                                if (reply.edited!) {
                                    Text("(edited)").fontWeight(.thin)
                                }
                                Spacer()
                                Text(reply.date!.formatted(.relative(presentation: .numeric)))
                            }.font(.footnote)
                            HStack {
                                Text(reply.content!).padding(.vertical, 1)
                                Spacer()
                            }
                            HStack {
                                Image(systemName: "arrow.up.circle.fill")
                                Text("\(reply.ups!)").font(.footnote)
                                Spacer()
                            }
                            ReplyView(replies: reply.replies, nestCount: nestCount+1)
                        }.padding(.leading).padding(.top)
                    }
                }
            }
        }
    }
}
