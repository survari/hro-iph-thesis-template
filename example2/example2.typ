#import "@local/hro-iph-seminar-paper:0.1.0": seminar-paper

// Take a look at the file `template.typ` in the file panel
// to customize this template and discover how it works.
#show: seminar-paper.with(
  title: "Abhandlung über das Schreiben einer Hausarbeit",

  authors: (
    "Anton Au'Tor",
  ),

  date: datetime.today(),
  faculty: "Fakultät für Exemplarität",
  institute: "Institut für Beispielarbeit",
  docent: "Prof. Dr. rer. nat. Peter Musterprofessor",
  course: "Seminar Angewandte Exemplarwissenschaft",
  matnr: "0123456789",
  address: [Musterweg 28, \ Musterstadt 12345],
  mail: "email@domain.com"
)

// use `typst --root .. c example2.typ` to get access to the custombib style.
#import "typst-custombib/typst-custombib.typ": *
#import "/custombib-hro-iph-style.typ": hro-iph-bibstyle

#tcb-style(hro-iph-bibstyle)
#tcb-bibliography("/example2/bibliography.yaml")

= Einleitung und Motivation
#lorem(200) #tcb-cite("Bealer1998")

= Hauptteil
#lorem(300) #tcb-cite("Beth1960")

== Herkunft des Lorem Ipsum
#lorem(300) #tcb-cite("BräunerGhilardi2007")
#lorem(200) #tcb-cite("Thiel1965")
#lorem(400) #tcb-cite("Kähle2005")

== Verwendung des Lorem Ipsum
#lorem(300) #tcb-cite("Blaber2023")
#lorem(100)
#lorem(200)

= Schluss
#lorem(300)

#pagebreak()
#tcb-show-bibliography()