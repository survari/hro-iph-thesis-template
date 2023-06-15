#let example(key, body) = {
  state("ttpe_examples").update(dict => {
    (dict, key).flatten()
  })

  locate(loc => {
    let dict = state("ttpe_examples").at(loc)

    v(1.5em, weak: true)
    grid(columns: (auto, auto),
      [(#{dict.len() - 1})] + h(1em),
      body)
  })
}

#let exref(key) = {
  let s = state("ttpe_examples")

  locate(loc => {
    let d = s.final(loc)

    if type(d) != "array" {
        text(fill: red, strong([ERROR DICT NOT ARRAY! IS #type(d)]))
    } else if key not in d {
        text(fill: red, strong([UNRESOLVED REFERENCE "#emph(key)"!]))
    } else {
      "(" + [#d.position(k => k == key)] + ")"
    }
  })
}

#let reset_example_counter() = {
}
