//
//  ContentView.swift
//  rickAndMorty
//
//  Created by ธนัท แสงเพิ่ม on 3/9/2564 BE.
//

import SwiftUI

struct characterList:Hashable, Codable{
    var results:[result]
    
    mutating func add(ls:characterList){
        results.append(contentsOf: ls.results)
    }
}

struct result:Hashable, Codable{
    let name:String
    let status:String
    let species:String
    let type:String
    let gender:String
    let origin:origin
    let location:location
    let image:String
    let episode:[String]
}

struct origin:Hashable, Codable{
    let name:String
}

struct location:Hashable, Codable{
    let name:String
}

class ViewModel:ObservableObject{
    @Published var resp:characterList = characterList(results:[])
        
    var page:Int = 1
    
    @Published var tableOn:Bool = false
    
    func fetch(){
        guard let url = URL(string: "https://rickandmortyapi.com/api/character?page=\(String(page))") else{return}
        let task = URLSession.shared.dataTask(with: url){
            data, res, err in
            guard let data = data , err == nil else {return}
            do{
                let chars = try JSONDecoder().decode(characterList.self, from: data)
                DispatchQueue.main.async {
//                    self.resp = chars
                    self.resp.add(ls: chars)
                }
            }catch{print(error)}
        }
        task.resume()
        print("fetch > ",page)
    }
    func tabOnOff(){
        tableOn.toggle()
    }
}

struct ContentView: View {
    @StateObject var viewModel = ViewModel()
    
    var body: some View {
        if viewModel.tableOn == false{
            NavigationView{
                List{
                    ForEach(viewModel.resp.results.indices, id:\.self){
                        chIndex in
                        NavigationLink(
                            destination: charDetail(charac:viewModel.resp.results[chIndex]),
                            label: { Text("\( viewModel.resp.results[chIndex].name)").bold() }
                        ).onAppear(perform: {
                            if chIndex > viewModel.resp.results.count-2{
                                viewModel.page += 1
                                viewModel.fetch()
                            }
                        })
                    }
                }
                    .navigationTitle("rick and morty list")
                    .onAppear(perform: viewModel.fetch)
            }
        }else{
            NavigationView{
                ScrollView{
                    LazyVGrid(columns: [GridItem(.adaptive(minimum: 100))], content: {
                        ForEach(viewModel.resp.results.indices, id: \.self){chIndex in
                                NavigationLink(
                                    destination: charDetail(charac:viewModel.resp.results[chIndex]),
                                    label: {
                                        VStack{
                                            Image(uiImage:viewModel.resp.results[chIndex].image.load())
                                                .resizable()
                                                .frame(width: 100, height: 100)
                                            Text(viewModel.resp.results[chIndex].name)
                                        }
                                    }
                                ).onAppear(perform: {
                                    if chIndex > viewModel.resp.results.count-2{
                                        viewModel.page += 1
                                        viewModel.fetch()
                                    }
                                })
                            }
                        }
                    )
                }
                .navigationTitle("rick and morty table")
            }
        }
        HStack{
            Spacer()
            if viewModel.tableOn{
                Button("list",action:viewModel.tabOnOff).font(.title)
            }else{
                Button("table",action:viewModel.tabOnOff).font(.title)
            }
            Spacer()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
