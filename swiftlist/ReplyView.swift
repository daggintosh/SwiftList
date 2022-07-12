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
                        Divider().frame(width:2).overlay(Color(.systemGray2))
                        VStack {
                            HStack {
                                Text("/u/\(reply.author!)").fontWeight(.bold).lineLimit(1)
                                switch(reply.op) {
                                case true:
                                    Text("OP").fontWeight(.bold).foregroundColor(.accentColor)
                                default:
                                    EmptyView()
                                }
                                Spacer()
                                HStack {
                                    Text(reply.date!.formatted(.relative(presentation: .numeric)))
                                    Spacer()
                                }
                            }.font(.footnote)
                            HStack {
                                Text(.init(reply.content!)).fixedSize(horizontal: false, vertical: true)
                                Spacer()
                            }
                            HStack {
                                Image(systemName: "arrow.up.circle.fill")
                                Text("\(reply.ups!)").font(.footnote)
                                Spacer()
                            }.padding(.top, 1)
                            ReplyView(replies: reply.replies, nestCount: nestCount+1)
                        }.padding(.leading,4)
                    }.fixedSize(horizontal: false, vertical: true)
                }
            }
        }
    }
}
