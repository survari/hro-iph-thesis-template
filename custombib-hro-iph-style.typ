// TODO: add english as a language for this style (Hrsg./ders.)

#let ifnotnone(elem, fn-true, fn-false: k => none) = if elem != none {
    fn-true(elem)
} else {
    fn-false(elem)
}

#let ifhaskey(elem, key, fn-true, ..k) = if elem.at(key, default: none) != none {
    fn-true(elem)
} else if k.pos().len() > 0 {
    k.pos().first()(elem)
}

#let dotted(s) = {
    let s = s.trim()
    return s.ends-with(".") or s.ends-with("!") or s.ends-with("?")
}

#let evc(e) = eval("["+e+"]")
#let dot(e) = if not dotted(e) { evc(e)+[.] } else { e }

#let make-title(element) = emph({
    evc(element.title)

    if "subtitle" in element and element.subtitle != none {
        if not dotted(element.title) {
            [. ]
        }

        dot(element.subtitle)

    } else if not dotted(element.title) {
        [.]
    }
})

#let make-booktitle(element) = {
    let element = element
    element.title = element.booktitle

    element.subtitle = if "booksubtitle" in element {
        element.booksubtitle
    } else {
        none
    }

    make-title(element)
}

#let hro-iph-bibstyle-types = (
    // == Monographie ==
    // Verfassername, Vorname: Titel. Untertitel. Auflage [falls nicht 1. Aufl.]. Ort Jahr.
    // Rosenberg, Jay F.: Philosophieren. Ein Handbuch für Anfänger. 6. Auflage. Frankfurt am Main 1986.
    // KEYS: authos, title, year, location, (pages, edition, volume, volume-title, series, series-volume)
    monography: (entry, element) => [#element.authors:
        #make-title(element)
        #ifhaskey(element, "volume", e => [Band #e.volume#ifhaskey(element, "volume-title", e => [: ]+emph(evc(e.volume-title))).])
        #ifhaskey(element, "series", e => [#ifhaskey(e, "series-volume", e => [Band ]+e.series-volume, e => [Teil ]) der Serie ]+emph(e.series)+[.])
        #ifhaskey(element, "edition", e => if int(e.edition) > 1 {
            e.edition+[. Auflage.]
        })
        #element.location #element.year.
        #ifhaskey(element, "pages", e => [S. #dot(e.pages)])
    ],

    // == Onlinequelle ==
    // Verfassername, Vorname: Titel. URL (Abfragedatum).
    // Sypnowich, Christine: Law and Ideology. http://plato.stanford.edu/entries/law-ideology/ (11.10.2014).
    // KEYS: authors, title, url, year
    url: (entry, element) => [#element.authors:
        #make-title(element)
        #raw(element.url)
        (letzter Zugriff #element.year).],

    // == Zeitschriftenaufsätze ==
    // Verfassername, Vorname: Titel. Untertitel. In: Zeitschriftentitel Jahrgangsnummer (Jahr). S. x-z.
    // Klager, Christian: Gerechte Verteilung – spielend leicht? In: ZDPE. Heft „Globale Gerechtigkeit“. Jg. 33 (3/2011). S. 200-203.
    // KEYS: authors, title, journal, (publisher, volume, issue, pages, url, year)
    article: (entry, element) => [
        #element.authors:
        #make-title(element)
        In: #emph(evc(element.journal)).
        #ifhaskey(element, "publisher", e => [Hrsg. von #element.publisher.join(", ", last: " und ").])
        #ifhaskey(element, "volume", element => [Jg. #element.volume (#ifhaskey(element, "issue", e => e.issue+[/])#element.year).])
        #ifhaskey(element, "pages", e => [S. #dot(e.pages)])
        #ifhaskey(element, "url", e => [URL: ]+link(e.url)+[ (letzter Zugriff #e.year)])
    ],

    // == Sammelbände/Herausgeberschriften ==
    // Autor X, Autor Y (Hgg.): Titel. Untertitel. Auflage. Ort Jahr.
    // Schönecker, Dieter und Wood, Allen W. (Hgg.): Kants „Grundlegung zur Metaphysik der Sitten“. Ein einführender Kommentar. Paderborn, München, Wien, Zürich 2002.
    // KEYS: authors, title, year, location, (volume, volume-title, edition)
    collection: (entry, element) => [
        #element.authors (#if entry.author.len() > 1 {[Hgg.]} else {[Hg.]}):
        #make-title(element)
        #ifhaskey(element, "volume", e => [Band #e.volume#ifhaskey(element, "volume-title", e => [: ]+emph(evc(e.volume-title))).])
        #ifhaskey(element, "edition", e => if int(e.edition) > 1 {
            e.edition+[. Auflage.]
        })
        #element.location
        #element.year.
        #ifhaskey(element, "pages", e => [S. #dot(e.pages)])
    ],

    // == Aufsätze in Sammelbänden ==
    // Verfassername, Vorname: Titel. Untertitel. In: Titel. Untertitel. Hrsg. von Vorname Nachname. Auflage [falls nicht 1. Aufl.]. Ort Jahr. S. x-z
    // Arendt, Hannah: Persönliche Verantwortung und Urteilsbildung. In: Ich denke, also bin ich. Grundtexte der Philosophie. Hrsg. von Ekkehard Martens. München 2006. S. 239-244.
    // KEYS: authors, title, publisher, location, year, (pages, volume, volume-title)
    collection-article: (entry, element) => [
        #element.authors:
        #make-title(element)
        In: #make-booktitle(element)
        #ifhaskey(element, "volume", e => [Band #e.volume#ifhaskey(element, "volume-title", e => [: ]+emph(evc(e.volume-title))).])
        Hrsg. von #element.publisher.join(", ", last: " und ").
        #ifhaskey(element, "edition", e => if int(e.edition) > 1 {
            e.edition+[. Auflage.]
        })
        #element.location
        #element.year.
        #ifhaskey(element, "pages", e => [S. #dot(e.pages)])
    ],

    // == Lexikonartikel ==
    // Verfassername, Vorname: Artikel. Lemma. In: Lexikon-Name, evtl. Band. Hrsg. von Vorname Nachname. Ort Jahr. S. x-z.
    // Prinz, Wolfgang: Erkennen, Erkenntnis. In: Historisches Wörterbuch der Philosophie. Band 2. Hrsg. von Joachim Ritter und Rudolf Eisler. Basel, Stuttgart 1972. S. 662-681.
    // KEYS: authors, title, booktitle, publisher, location, year, (pages, volume, volume-title)
    lexicon: (entry, element) => [
        #element.authors:
        #make-title(element)
        In: #make-booktitle(element)
        #ifhaskey(element, "volume", e => [Band #e.volume#ifhaskey(element, "volume-title", e => [: ]+emph(evc(e.volume-title))).])
        Hrsg. von #element.publisher.join(", ", last: " und ").
        #ifhaskey(element, "edition", e => if int(e.edition) > 1 {
            e.edition+[. Auflage.]
        })
        #element.location
        #element.year.
        #ifhaskey(element, "pages", e => [S. #dot(e.pages)])
    ],

    // == Werkausgabe ==
    // Verfassername, Vorname: Titel. In: ders.: Titel der Ausgabe. Hrsg. von Vorname Nachname. Bandnummer: Bandtitel. Ort Jahr. S. x-z.
    // Fink, Eugen: Oase des Glücks. In: ders.: Eugen Fink Gesamtausgabe. Hrsg. von Stephan Grätzel, Cathrin Nielsen, Hans Rainer Sepp. Bd. 7: Spiel als Weltsymbol. München 2010. S. 11-29.
    // KEYS: authors, title, booktitle, publisher, location, year, (pages, volume, edition)
    edition: (entry, element) => [
        #element.authors:
        #make-title(element)
        In: ders.: #make-booktitle(element)
        Hrsg. von #element.publisher.join(", ", last: " und ").
        #ifhaskey(element, "volume", e => [Band #e.volume#ifhaskey(element, "volume-title", e => [: ]+emph(evc(e.volume-title))).])
        #ifhaskey(element, "edition", e => if int(e.edition) > 1 {
            e.edition+[. Auflage.]
        })
        #element.location
        #element.year.
        #ifhaskey(element, "pages", e => [S. #dot(e.pages)])
    ],

    fallback: (entry, element) => [#element.authors: #emph["#element.title"]. #element.year.]
)

#let clear-pages(style, key) = {
    let style = style

    style.at(key) = (entry, element) => {
        element.pages = none
        hro-iph-bibstyle-types.at(key)(entry, element)
    }

    style
}

// changes specific for bibliography
#let hro-iph-bibstyle-types-bibliography = {
    let bst = hro-iph-bibstyle-types

    // remove pages from ...
    bst = clear-pages(bst, "monography")
    bst = clear-pages(bst, "collection")

    bst
}

#let hro-iph-bibstyle = (
    options: (
        is-numerical: false,
        show-sections: true,
        show-bibliography: true,
        title: "Bibliographie",
        separator: ", "
    ),

    // how each field is formatted (from entry (source-string) to citation (content))
    fields: (
        // performed on each author name
        author: (entry, author) =>
            smallcaps(author.last
                + ifhaskey(author, "first", e => [, #e.first])
                + ifhaskey(author, "middle", e => [ ] + e.middle
                    .split(" ")
                    .map(e => e.split("-")
                        .map(e => e.at(0)+[.])
                        .join("-"))
                    .join(" "))),

        // performed on the list of authors
        authors: (entry, authors) =>
            (if authors.len() >= 3 {
                authors.at(0) + [, ] + authors.at(1) + [ et al.]
            } else {
                authors.join(" und ")
            }),

        publisher: (entry, publisher) => (publisher,).flatten(),

        // performed on each prefix and postfix
        postfix: (entry, postfix) => [#ifnotnone(postfix, e => [, #postfix])],
        prefix: (entry, prefix) => [#ifnotnone(prefix, e => [#e ])],

        // title: (entry, field) => eval("["+field+"]"),

        // fallback
        fallback: (entry, field) => field
    ),

    // for entry-type "custom"
    custom: (
        sort-by: "marker",
        inline: (entry) => [#ifhaskey(entry, "prefix", e => (e.prefix+" "))#eval("["+entry.show-inline+"]")],//#ifhaskey(entry, "postfix", e => (" "+e.postfix))],
        bibliography: (entry) => [#eval("["+entry.show-bibliography+"]").]
    ),

    inline: (
        // fields: (
            // performed on each author name
            // author: (entry, author) =>
            //     smallcaps(if author.first != none { [#author.first.at(0)] + [. ] }
            //         + ifhaskey(author, "middle", e => [ #e.middle ])
            //         + [ ]
            //         + author.last)
        // ),

        // added after citation
        citation-begin: (entry, citation) => citation,

        // added before citation
        citation-end: (entry, citation) => citation,

        // format single citation inside
        format: (entry, citation) => [#ifhaskey(entry, "prefix", e => e.prefix+[ ]) #citation #ifhaskey(entry, "postfix", e => e.postfix+[ ])],

        // on multiple citations, wrap all of them into this
        wrap-multi: (citations) => [#citations],

        // on all citations cited together tcb-cites / tcb-cite, wrap all of them into this
        wrap-any: (citations) => [#citations],

        mutator: (entry) => {
            if entry.postfix != none and entry.postfix.trim().starts-with("S.") {
                entry.pages = none
            }

            return entry
        },

        types: hro-iph-bibstyle-types
    ),

    bibliography: (
        format: (entry, citation) => {
            set par(leading: 0.65em)
            citation
        },

        types: hro-iph-bibstyle-types-bibliography
    ),

    sections: (
        primary: "Primärliteratur",
        secondary: "Sekundärliteratur",
        other: "Sonstige"
    )
)