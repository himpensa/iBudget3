//
//  NewCategoryView.swift
//  iBudget
//
//  Created by Antoine Himpens on 09/02/2024.
//

import SwiftUI
import SwiftData

struct NewCategoryView: View {
    @Environment(\.dismiss) var dismiss
    @Environment(\.modelContext) var modelContext
    @Binding var showingSheet: Bool
    @State private var showingConfirmationAlert = false

    @State private var categoryIcon = String()
    @State private var categoryName = String()
    
    let icons = [
        "circle.hexagongrid.circle",
        "pencil.circle",
        "trash.circle",
        "folder.circle",
        "paperplane.circle",
        "tray.circle",
        "archivebox.circle",
        "doc.circle",
        "calendar.circle",
        "book.circle",
        "newspaper.circle",
        "bookmark.circle",
        "graduationcap.circle",
        "backpack.circle",
        "paperclip.circle",
        "link.circle",
        "personalhotspot.circle",
        "person.circle",
        "sportscourt.circle",
        "soccerball.circle",
        "baseball.circle",
        "basketball.circle",
        "football.circle",
        "tennisball.circle",
        "volleyball.circle",
        "trophy.circle",
        "command.circle",
        "restart.circle",
        "power.circle",
        "eject.circle",
        "moon.circle",
        "cloud.circle",
        "smoke.circle",
        "wind.circle",
        "snowflake.circle",
        "tornado.circle",
        "drop.circle",
        "flame.circle",
        "play.circle",
        "pause.circle",
        "stop.circle",
        "record.circle",
        "playpause.circle",
        "backward.circle",
        "forward.circle",
        "shuffle.circle",
        "repeat.circle",
        "infinity.circle",
        "sos.circle",
        "speaker.circle",
        "magnifyingglass.circle",
        "mic.circle",
        "smallcircle.circle",
        "circle.grid.3x3.circle",
        "diamond.circle",
        "heart.circle",
        "star.circle",
        "flag.circle",
        "location.circle",
        "bell.circle",
        "tag.circle",
        "bolt.circle",
        "icloud.circle",
        "camera.circle",
        "message.circle",
        "bubble.circle",
        "phone.circle",
        "teletype.circle",
        "video.circle",
        "envelope.circle",
        "gear.circle",
        "gearshape.circle",
        "scissors.circle",
        "ellipsis.circle",
        "bag.circle",
        "cart.circle",
        "creditcard.circle",
        "hammer.circle",
        "stethoscope.circle",
        "handbag.circle",
        "briefcase.circle",
        "theatermasks.circle",
        "house.circle",
        "storefront.circle",
        "lightbulb.circle",
        "popcorn.circle",
        "washer.circle",
        "dryer.circle",
        "dishwasher.circle",
        "toilet.circle",
        "tent.circle",
        "lock.circle",
        "wifi.circle",
        "pin.circle",
        "mappin.circle",
        "map.circle",
        "iphone.circle",
        "visionpro.circle",
        "headphones.circle",
        "tv.circle",
        "airplayvideo.circle",
        "airplayaudio.circle",
        "airplane.circle",
        "car.circle",
        "tram.circle",
        "sailboat.circle",
        "bicycle.circle",
        "parkingsign.circle",
        "fuelpump.circle",
        "steeringwheel.circle",
        "microbe.circle",
        "pill.circle",
        "pills.circle",
        "cross.circle",
        "staroflife.circle",
        "hare.circle",
        "tortoise.circle",
        "dog.circle",
        "cat.circle",
        "lizard.circle",
        "bird.circle",
        "ant.circle",
        "ladybug.circle",
        "fish.circle",
        "pawprint.circle",
        "leaf.circle",
        "tree.circle",
        "tshirt.circle",
        "shoe.circle",
        "film.circle",
        "eye.circle",
        "viewfinder.circle",
        "photo.circle",
        "shippingbox.circle",
        "clock.circle",
        "timer.circle",
        "circle.dotted.and.circle",
        "waveform.circle",
        "gift.circle",
        "hourglass.circle",
        "purchased.circle",
        "grid.circle",
        "recordingtape.circle",
        "binoculars.circle",
        "info.circle",
        "at.circle",
        "questionmark.circle",
        "exclamationmark.circle",
        "plus.circle",
        "minus.circle",
        "plusminus.circle",
        "multiply.circle",
        "divide.circle",
        "equal.circle",
        "lessthan.circle",
        "greaterthan.circle",
        "number.circle",
        "xmark.circle",
        "checkmark.circle",
        "slash.circle",
        "asterisk.circle",
        "left.circle",
        "right.circle",
        "a.circle",
        "b.circle",
        "c.circle",
        "d.circle",
        "e.circle",
        "f.circle",
        "g.circle",
        "h.circle",
        "i.circle",
        "j.circle",
        "k.circle",
        "l.circle",
        "m.circle",
        "n.circle",
        "o.circle",
        "p.circle",
        "q.circle",
        "r.circle",
        "s.circle",
        "t.circle",
        "u.circle",
        "v.circle",
        "w.circle",
        "x.circle",
        "y.circle",
        "z.circle",
        "dollarsign.circle",
        "centsign.circle",
        "yensign.circle",
        "sterlingsign.circle",
        "francsign.circle",
        "florinsign.circle",
        "turkishlirasign.circle",
        "rublesign.circle",
        "eurosign.circle",
        "0.circle",
        "1.circle",
        "2.circle",
        "3.circle",
        "4.circle",
        "5.circle",
        "6.circle",
        "7.circle",
        "8.circle",
        "9.circle",
        "trash.slash.circle",
        "xmark.bin.circle",
        "arrowshape.left.circle",
        "arrowshape.backward.circle",
        "arrowshape.right.circle",
        "arrowshape.forward.circle",
        "arrowshape.up.circle",
        "arrowshape.down.circle",
        "books.vertical.circle",
        "book.closed.circle",
        "person.2.circle",
        "person.crop.circle",
        "photo.artframe.circle",
        "person.bust.circle",
        "figure.2.circle",
        "figure.walk.circle",
        "figure.wave.circle",
        "figure.fall.circle",
        "figure.run.circle",
        "tennis.racket.circle",
        "hockey.puck.circle",
        "cricket.ball.circle",
        "dot.circle.and.cursorarrow",
        "sun.max.circle",
        "sun.horizon.circle",
        "sun.dust.circle",
        "sun.haze.circle",
        "sun.rain.circle",
        "sun.snow.circle",
        "moon.dust.circle",
        "moon.haze.circle",
        "moon.stars.circle",
        "cloud.drizzle.circle",
        "cloud.rain.circle",
        "cloud.heavyrain.circle",
        "cloud.fog.circle",
        "cloud.hail.circle",
        "cloud.snow.circle",
        "cloud.sleet.circle",
        "cloud.bolt.circle",
        "cloud.sun.circle",
        "cloud.moon.circle",
        "wind.snow.circle",
        "thermometer.sun.circle",
        "thermometer.snowflake.circle",
        "backward.end.circle",
        "forward.end.circle",
        "repeat.1.circle",
        "speaker.slash.circle",
        "music.mic.circle",
        "mic.slash.circle",
        "circle.lefthalf.striped.horizontal",
        "square.on.circle",
        "heart.slash.circle",
        "flag.slash.circle",
        "flag.checkered.circle",
        "location.slash.circle",
        "location.north.circle",
        "bell.slash.circle",
        "bell.badge.circle",
        "bolt.slash.circle",
        "bolt.horizontal.circle",
        "flashlight.off.circle",
        "flashlight.on.circle",
        "flashlight.slash.circle",
        "message.badge.circle",
        "bubble.right.circle",
        "bubble.left.circle",
        "exclamationmark.bubble.circle",
        "phone.down.circle",
        "teletype.answer.circle",
        "video.slash.circle",
        "cross.case.circle",
        "building.columns.circle",
        "bed.double.circle",
        "tent.2.circle",
        "house.lodge.circle",
        "signpost.left.circle",
        "signpost.right.circle",
        "mountain.2.circle",
        "wifi.exclamationmark.circle",
        "mappin.slash.circle",
        "rotate.3d.circle",
        "iphone.gen1.circle",
        "iphone.gen2.circle",
        "iphone.gen3.circle",
        "iphone.slash.circle",
        "visionpro.slash.circle",
        "bolt.car.circle",
        "figure.child.circle",
        "camera.macro.circle",
        "eye.slash.circle",
        "hand.raised.circle",
        "hand.thumbsup.circle",
        "hand.thumbsdown.circle",
        "f.cursive.circle",
        "fork.knife.circle",
        "circle.and.line.horizontal",
        "battery.100percent.circle",
        "list.bullet.circle",
        "square.and.pencil.circle",
        "pencil.tip.crop.circle",
        "shared.with.you.circle",
        "person.crop.circle.badge",
        "person.crop.circle.dashed",
        "cloud.bolt.rain.circle",
        "cloud.sun.rain.circle",
        "cloud.sun.bolt.circle",
        "cloud.moon.rain.circle",
        "cloud.moon.bolt.circle",
        "speaker.wave.2.circle",
        "circle.lefthalf.striped.horizontal.inverse",
        "rectangle.on.rectangle.circle",
        "flag.2.crossed.circle",
        "house.and.flag.circle",
        "building.2.crop.circle",
        "mappin.and.ellipse.circle",
        "iphone.gen1.slash.circle",
        "iphone.gen2.slash.circle",
        "iphone.gen3.slash.circle",
        "square.and.arrow.up.circle",
        "person.crop.circle.badge.plus",
        "person.crop.circle.badge.minus",
        "person.crop.circle.badge.checkmark",
        "person.crop.circle.badge.xmark",
        "person.crop.circle.badge.questionmark",
        "person.crop.circle.badge.exclamationmark",
        "person.crop.circle.badge.moon",
        "person.crop.circle.badge.clock",
        "thermometer.variable.and.figure.circle",
        "rectangle.on.rectangle.slash.circle",
        "play.rectangle.on.rectangle.circle",
        "phone.arrow.up.right.circle",
        "line.3.crossed.swirl.circle",
        "signpost.right.and.left.circle",
        "signpost.and.arrowtriangle.up.circle",
        "chart.line.uptrend.xyaxis.circle",
        "chart.line.downtrend.xyaxis.circle",
        "chart.line.flattrend.xyaxis.circle",
        "line.3.horizontal.decrease.circle",
        "line.2.horizontal.decrease.circle",
        "arrow.forward.to.line.circle",
        "arrow.triangle.2.circlepath.circle",
        "exclamationmark.arrow.circlepath",
        "clock.arrow.2.circlepath",
        "dollarsign.arrow.circlepath",
       ] // Liste des icônes SF Symbols disponibles
   
    let columns: [GridItem] = Array(repeating: .init(.flexible()), count: 4)

    
    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("Category Name")) {
                    TextField("Name", text: $categoryName)
                }
                Section(header: Text("Icon")) {
                    LazyVGrid(columns: columns, alignment: .center, spacing: 10) {
                        ForEach(icons, id: \.self) { icon in
                            Image(systemName: icon)
                                .resizable()
                                .scaledToFit()
                                .frame(width: 40, height: 40)
                                .padding()
                                .foregroundColor(categoryIcon == icon ? .blue : .gray) // Changez les couleurs selon vos préférences
                                .onTapGesture {
                                    categoryIcon = icon
                                }
                        }
                    }
                }

            }
            .navigationBarTitle(Text("New Category"), displayMode: .inline)
            .navigationBarItems(leading: Button(action: {
                showingConfirmationAlert = true
            }) {
                Text("Cancel").foregroundColor(.red)
                    .alert(isPresented: $showingConfirmationAlert) {
                        Alert(title: Text("Are you sure?"), message: Text("Your changes will not be saved."), primaryButton: .default(Text("Yes")) {
                            dismiss()
                        }, secondaryButton: .cancel(Text("No")))
                    }
            }, trailing: Button(action: {
                print("Saved")
                addCategory()
                dismiss()
            }) {
                Text("Save").bold()
            })
        }
    }
    
    func addCategory() {
        print(categoryIcon)
        print(categoryName)

        let category = Category(category_name: categoryName, category_icon: categoryIcon, parentID: nil)
        
        modelContext.insert(category)
    }
    
    
}

#Preview {
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
      let container = try! ModelContainer(for: Category.self, configurations: config)

    let sampleCategory = Category(category_name: "Restaurant", category_icon: "questionmark.circle", parentID: nil)


    return EditCategoryView(category: sampleCategory)
        .modelContainer(container)
}
