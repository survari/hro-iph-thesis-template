# HRO IPH Seminar Paper Template

Inofficial template following the standards of the Institute of Philosophy's Methodenüberlebenskoffer (MÜK, "methods survival kit") at the University of Rostock.

## Installation

Either install it as a local package and import it using:

```
#import "@local/hro-iph-seminar-paper:0.1.0": seminar-paper
```

or copy the `template.typ` into your typst project and import it using:

```
#import "template.typ": seminar-paper
```

## Bibliography

Right now [CSL](https://citationstyles.org/) support is being implemented for Typst. As an alternative, you can use [typst-custombib](https://github.com/survari/typst-custombib/) and the `custombib-hro-iph-style.typ` provided by this package to get a bibliography style that conforms the MÜK.

Copy the `custombib-hro-iph-style.typ` into your project, import the `typst-custombib` library and use it like this:

```
#import "custombib-hro-iph-style.typ": hro-iph-bibstyle

#tcb-style(hro-iph-bibstyle)
#load
```

### Bibliography Source
The source is given as a YAML-file. Each entry is an entry like this:
```yaml
Montague1970:
  entry-type: article
  author: Richard Montague
  title: Pragmatics and Intensional Logic
  journal: Synthese
  volume: 22
  issue: 1-2
  year: 1970
  pages: 68-94
  section: primary
```

The special fields `enty-type` and `section` specify what type of object the entry is (e.g. `monography`, `article`, ...) and which section it should be listed (either `primary` or `secondary`, or remove the field to not differentiate between primary and secondary literature).

The `entry-type` can be one of the following, each having custom fields (optional fields in parentheses):

- `monography`: authos, title, year, location, (pages, edition, volume, volume-title, series, series-volume)
- `url`: authors, title, url, year
- `article`: authors, title, journal, (publisher, volume, issue, pages, url, year)
- `collection`: authors, title, year, location, (volume, volume-title, edition)
- `collection-article`: authors, title, publisher, location, year, (pages, volume, volume-title)

See [`example2/example2.typ`](example2/example2.pdf) for a working example.