// Word and sentence banks used to build practice drills (German edition,
// QWERTZ layout). Pure data, no QML/Quickshell dependencies, so it can be
// unit-reasoned about or replaced independently of the UI.
.pragma library

// Only uses letters reachable without leaving the home row: a s d f g h j k l ö ä.
// All entries are correct German in lowercase (no nouns), so the early
// levels never need Shift.
var homeRowWords = [
  "da", "ja", "jaja", "all", "als", "das", "dass", "las", "lag", "sah",
  "sag", "lass", "falls", "gaga", "halal", "lalala", "ah", "\u00e4h", "h\u00e4h"
]

// Common words that avoid the bottom row entirely (no y x c v b n m).
var topRowWords = [
  "der", "die", "das", "dies", "wer", "wo", "was", "wie", "sie", "so",
  "tot", "t\u00fcr", "f\u00fcr", "f\u00fcrs", "ist", "es", "sei", "ihr", "euer", "aus",
  "auf", "oft", "zu", "zur", "zwei", "drei", "tag", "tage", "gut", "gute",
  "fest", "fragt", "sp\u00e4t", "sp\u00e4ter", "woher", "wohl", "fertig", "lustig",
  "traurig", "hoffe", "weit", "reif", "feuer", "stadt", "pfad", "pfeil",
  "gruppe", "zeit", "seite", "reise", "wasser", "pass", "sollte", "wollte",
  "dort", "hier", "jetzt", "jedes", "jeder", "heute", "ruhe", "ruhig",
  "fr\u00fch", "h\u00f6rt", "h\u00f6re", "spiel", "spielt", "quer", "quark", "quartal",
  "zitat", "zeuge"
]

// General common-German word list covering the full alphabet incl. \u00e4 \u00f6 \u00fc \u00df,
// used for the full-alphabet and mixed levels. Nouns are lowercase here
// only where they are lowercase in German too; the "mixed" level adds
// capitals on top.
var commonWords = [
  "der", "die", "und", "in", "den", "von", "zu", "das", "mit", "sich",
  "des", "auf", "f\u00fcr", "ist", "im", "dem", "nicht", "ein", "eine", "als",
  "auch", "es", "an", "werden", "aus", "er", "hat", "dass", "sie", "nach",
  "wird", "bei", "einer", "um", "am", "sind", "noch", "wie", "einem", "\u00fcber",
  "einen", "so", "zum", "war", "haben", "nur", "oder", "aber", "vor", "zur",
  "bis", "mehr", "durch", "man", "sein", "wurde", "sei", "prozent", "hatte", "kann",
  "gegen", "vom", "schon", "wenn", "habe", "seine", "mark", "ihre", "dann", "unter",
  "wir", "soll", "ich", "eines", "es", "jahr", "zwei", "jahren", "diese", "dieser",
  "wieder", "keine", "uns", "da", "hier", "sehr", "ihr", "bereits", "gibt", "viele",
  "gro\u00df", "gr\u00f6\u00dfer", "sch\u00f6n", "m\u00fcssen", "k\u00f6nnen", "w\u00fcrde", "f\u00fcnf", "zw\u00f6lf", "stra\u00dfe",
  "wei\u00df", "hei\u00df", "fu\u00df", "gr\u00fc\u00dfen", "sp\u00e4ter", "m\u00e4dchen", "k\u00e4se", "b\u00e4ume", "t\u00e4glich",
  "\u00e4hnlich", "\u00fcbung", "\u00f6ffnen", "j\u00e4hrlich", "mutter", "vater", "kind", "haus",
  "zeit", "welt", "leben", "arbeit", "freund", "wasser", "essen", "trinken",
  "xylophon", "boxen", "quelle", "vogel", "zebra", "jagen", "wirklich", "gl\u00fcck"
]

// Characters for the "numbers & punctuation" level: only keys reachable
// without a dead key (^ \u00b4 `) so every keystroke produces its character.
var punctuationChars = [
  ",", ".", "-", "#", "+", "0", "1", "2", "3", "4", "5", "6", "7", "8", "9"
]

var sentences = [
  "Zw\u00f6lf Boxk\u00e4mpfer jagen Viktor quer \u00fcber den gro\u00dfen Sylter Deich.",
  "Falsches \u00dcben von Xylophonmusik qu\u00e4lt jeden gr\u00f6\u00dferen Zwerg.",
  "Franz jagt im komplett verwahrlosten Taxi quer durch Bayern.",
  "Zwei flinke Boxer jagen die quirlige Eva und ihren Mops durch Sylt.",
  "\u00dcbung macht den Meister, nicht Perfektion.",
  "Tippe am Anfang langsam, die Geschwindigkeit kommt von allein.",
  "Halte die Finger gebogen und lege sie auf die Grundreihe.",
  "Eine gute Haltung hilft dir, l\u00e4nger ohne Erm\u00fcdung zu schreiben.",
  "Kleine Schritte jeden Tag f\u00fchren mit der Zeit zu gro\u00dfen Fortschritten.",
  "Schau auf den Bildschirm, nicht auf deine H\u00e4nde, w\u00e4hrend du tippst.",
  "Ein gleichm\u00e4\u00dfiger Rhythmus ist wertvoller als ein schneller Sprint.",
  "Best\u00e4ndigkeit schl\u00e4gt Intensit\u00e4t, wenn man etwas Neues lernt.",
  "Jeder Experte war einmal ein Anf\u00e4nger, der weitergemacht hat.",
  "Mach eine kurze Pause, wenn deine H\u00e4nde m\u00fcde werden.",
  "Gut gemacht! Du hast wieder eine \u00dcbungseinheit abgeschlossen."
]

function wordList(name) {
  if (name === "homeRow") return homeRowWords
  if (name === "topRow") return topRowWords
  return commonWords
}
