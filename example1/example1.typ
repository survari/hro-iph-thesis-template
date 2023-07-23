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

= Einleitung und Motivation
#lorem(200)

= Hauptteil
#lorem(300)

== Herkunft des Lorem Ipsum
#lorem(300)
#lorem(200)
#lorem(400)

== Verwendung des Lorem Ipsum
#lorem(300)
#lorem(100)
#lorem(200)

= Schluss
#lorem(300)