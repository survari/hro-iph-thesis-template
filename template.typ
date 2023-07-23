// #import "outline-template.typ": *

#let MONTHS = ("Januar", "Februar", "März", "April", "Mai", "Juni",
  "Juli", "August", "Septbember", "Oktober", "November", "Dezember")

#let SUMMER_MONTHS = ("April", "Mai", "Juni", "Juli", "August",
  "September")

#let date-today-de(date) = date.display("[day padding:zero]")+". "+MONTHS.at(date.month() - 1)+" "+date.display("[year]")

#let gen-date(date) = {
  if date.split(" ").len() < 2 {
    "<SEMESTER>"

  } else {
    let year = date.split(" ").at(2).slice(2)

    if date.split(" ").at(1) in SUMMER_MONTHS {
      "Sommersemester 20" + year
    } else {
      "Wintersemester 20" + year + "/" + str(int(year) + 1)
    }
  }

  [\ #date]
}

#let todo(body) = block(inset: 1em,
  stroke: (left: 1pt + red),
  width: 100%,
  fill: red.lighten(90%),
  pad(bottom: 0.5em, strong[To Do])+body)

#let seminar-paper(title: "",
  authors: (),
  university: none,
  faculty: "<FACULTY>",
  institute: "<INSTITUTE>",
  docent: "<DOCENT>",
  course: "<COURSE>",
  matnr: "<MATNR>",
  date: "<DATE>",
  address: "<ADDRESS>",
  mail: "<MAIL>",
  body) = {

  // ==== document setup ========
  set document(author: authors, title: title)
  set page(numbering: "1", number-align: center, paper: "a4")
  set text(font: "Times New Roman", lang: "de", size: 12pt)
  set heading(numbering: "1.1.")

  // ==== first page ========
  set page(footer: [])
  align(center + horizon, [
    // make font title page a bit bigger than in the rest of the document
    #set text(size: 1.25em)

    // title
    #pad(right: 2em, left: 2em, block(text(2em, strong(title))))

    #v(2cm)
    // university
    #if university == none {
      image("UNI-Logo_Siegel_4c_149mm_06.png", width: 50%)
    } else {
      text(size: 1.25em, university)
    }

    // generate table
    #align(top, pad(left: 2em, right: 2em,
      table(stroke: white, columns: (40%, 60%),

      ..("Fakultät:", faculty,
        "Institut:", institute,
        "Dozent:", docent,
        "Veranstaltung:", course,
        "", "", // one free line

        "Verfasser:", authors.join([, \ ], last: [\ und ]),
        "Matrikel-Nr.:", matnr,
        "Adresse:", address,
        "E-Mail:", raw(mail),

      ).map(e =>
        if type(e) == "string" and e.trim().ends-with(":") {
          strong(align(right)[#e])
        } else {
          align(left)[#e]
        }
      )
    )))

    #v(2cm)
    // display date and semester
    #gen-date(date-today-de(date))
  ])

  pagebreak()
  set page(margin: (right: 4cm))

  // ==== outline ========
  set par(justify: true)
  show outline.entry.where(
    level: 1
  ): it => {
    v(12pt, weak: true)
    strong(it)
  }
  outline(indent: true)

  pagebreak()

  // ==== main body ========

  // 1.5 line distance, but approximated as 1.25em
  set par(leading: 1.25em)

  // make each heading have some space around it
  show heading: e => v(2em, weak: true) + e + v(1em, weak: true)

  set page(footer: align(center, counter(page).display()))
  counter(page).update(1)
  body

  pagebreak()
  // set page(footer: [], header: [], margin: (right: 3cm, top: 2cm)) // lets not use this anymore
  counter(page).update(e => e - 1)

  heading(outlined: false, numbering: none, [Selbstständigkeitserklärung])
  [Hiermit versichere ich, dass ich die vorliegende schriftliche Hausarbeit (Seminararbeit, Belegarbeit) selbstständig verfasst und keine anderen als die von mir angegebenen Quellen und Hilfsmittel benutzt habe. Die Stellen der Arbeit, die anderen Werken wörtlich oder sinngemäß entnommen sind, wurden in jedem Fall unter Angabe der Quellen (einschließlich des World Wide Web und anderer elektronischer Text- und Datensammlungen) kenntlich gemacht. Dies gilt auch für beigegebene Zeichnungen, bildliche Darstellungen, Skizzen und dergleichen. Ich versichere weiter, dass die Arbeit in gleicher oder ähnlicher Fassung noch nicht Bestandteil einer Prüfungsleistung oder einer schriftlichen Hausarbeit (Seminararbeit, Belegarbeit) war. Mir ist bewusst, dass jedes Zuwiderhandeln als Täuschungsversuch zu gelten hat, aufgrund dessen das Seminar oder die Übung als nicht bestanden bewertet und die Anerkennung der Hausarbeit als Leistungsnachweis/Modulprüfung (Scheinvergabe) ausgeschlossen wird. Ich bin mir weiter darüber im Klaren, dass das zuständige Lehrerprüfungsamt/Studienbüro über den Betrugsversuch informiert werden kann und Plagiate rechtlich als Straftatbestand gewertet werden.]

  v(1cm)

  table(columns: (auto, auto, auto, auto),
    stroke: white,
    inset: 0cm,

    strong([Ort:]) + h(0.5cm),
    repeat("."+hide("'")),
    h(0.5cm) + strong([Unterschrift:]) + h(0.5cm),
    repeat("."+hide("'")),
    v(0.75cm) + strong([Datum:]) + h(0.5cm),
    v(0.75cm) + repeat("."+hide("'")),)
}
