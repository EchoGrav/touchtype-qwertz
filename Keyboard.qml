import QtQuick
import qs.Commons

// On-screen German QWERTZ keyboard (DIN 2137 T1, ISO) that highlights the next key the user
// needs to press. Colors are fully derived from the Color/Style singletons
// so it matches whatever Omarchy theme is active. Purely visual — it does
// not read real keyboard events itself.
Item {
  id: root

  // Next character the drill expects, exactly as it appears in the target
  // text (may be uppercase, a digit, punctuation, or a single space).
  property string nextChar: ""
  // Finger color-coding (set by the lesson screen for Finger Gym levels):
  // keyFingerMap maps a board key ("q", ";", "1", "-", ...) to a finger id
  // ("index" | "middle" | "ring" | "pinky"), fingerColors maps each finger
  // id to its display color, and activeFinger restricts the zone tint to a
  // single finger pair ("" = tint every mapped key, for combined levels).
  property var keyFingerMap: ({})
  property var fingerColors: ({})
  property string activeFinger: ""
  property real keySize: Style.space(34)
  property real keyGap: Style.spacing.xs

  // Shifted symbols map back to their base key; everything else matches the
  // board directly (board rows are lowercase letters, digits, or literal
  // symbols as printed on the German keycaps).
  readonly property var shiftMap: ({
    "!": "1", "\"": "2", "\u00a7": "3", "$": "4", "%": "5", "&": "6", "/": "7", "(": "8", ")": "9", "=": "0",
    "?": "\u00df", "`": "\u00b4", "*": "+", "'": "#", ";": ",", ":": ".", "_": "-", ">": "<", "\u00b0": "^"
  })
  // Characters reached with AltGr (third level) on the German layout.
  readonly property var altGrMap: ({
    "\u00b2": "2", "\u00b3": "3", "{": "7", "[": "8", "]": "9", "}": "0", "\\": "\u00df",
    "@": "q", "\u20ac": "e", "~": "+", "|": "<", "\u00b5": "m"
  })
  readonly property string baseKey: {
    if (root.nextChar === "" || root.nextChar === " ") return root.nextChar
    if (root.shiftMap[root.nextChar] !== undefined) return root.shiftMap[root.nextChar]
    if (root.altGrMap[root.nextChar] !== undefined) return root.altGrMap[root.nextChar]
    var lower = root.nextChar.toLowerCase()
    return lower
  }
  readonly property bool isUpperLetter: root.nextChar !== "" && root.nextChar !== root.nextChar.toLowerCase() && root.nextChar === root.nextChar.toUpperCase()
  readonly property bool needsShift: root.isUpperLetter || root.shiftMap[root.nextChar] !== undefined
  readonly property bool needsAltGr: root.altGrMap[root.nextChar] !== undefined

  // Full-size ISO layout modeled on a real German keyboard: staggered rows
  // via wide edge keys, "<" next to the left Shift, "#" before Enter, and
  // Ctrl/Win/Alt + AltGr around a wide spacebar. Every row is 15 units wide.
  // "enterTop" and "enter" together stand in for the tall ISO Enter key.
  // Modifier keys are purely visual (drills never expect them) except Shift
  // and AltGr, which light up when the next character needs them, and Space,
  // which lights up for word gaps. Reads no real keyboard events itself.
  readonly property var rows: [
    ["^", "1", "2", "3", "4", "5", "6", "7", "8", "9", "0", "\u00df", "\u00b4", "backspace"],
    ["tab", "q", "w", "e", "r", "t", "z", "u", "i", "o", "p", "\u00fc", "+", "enterTop"],
    ["caps", "a", "s", "d", "f", "g", "h", "j", "k", "l", "\u00f6", "\u00e4", "#", "enter"],
    ["shiftL", "<", "y", "x", "c", "v", "b", "n", "m", ",", ".", "-", "shiftR"],
    ["ctrl", "win", "alt", "space", "altgr", "win", "menu", "ctrl"]
  ]

  // Widths in key units; anything unlisted is a standard 1-unit key.
  readonly property var keyWidths: ({ "backspace": 2, "tab": 1.5, "enterTop": 1.5, "caps": 1.75, "enter": 1.25, "shiftL": 1.25, "shiftR": 2.75, "space": 8 })
  // Display labels; anything unlisted shows as its uppercase self.
  readonly property var keyLabels: ({ "tab": "Tab", "caps": "Caps", "enter": "Enter", "enterTop": "\u21b5", "shiftL": "\u21e7", "shiftR": "\u21e7", "backspace": "\u232b", "ctrl": "Strg", "alt": "Alt", "altgr": "AltGr", "win": "Win", "menu": "Menu", "space": "space", "\u00df": "\u00df" })

  implicitWidth: column.implicitWidth
  implicitHeight: column.implicitHeight

  Column {
    id: column
    anchors.centerIn: parent
    spacing: root.keyGap

    Repeater {
      model: root.rows

      Row {
        required property var modelData
        required property int index
        spacing: root.keyGap

        Repeater {
          model: parent.modelData

          Rectangle {
            id: keyCap
            required property string modelData
            readonly property bool isShiftKey: modelData === "shiftL" || modelData === "shiftR"
            readonly property bool isSpaceKey: modelData === "space"
            readonly property bool isHome: modelData === "f" || modelData === "j"
            readonly property bool isAltGrKey: modelData === "altgr"
            readonly property bool active: isShiftKey ? root.needsShift
              : (isAltGrKey ? root.needsAltGr
              : (isSpaceKey ? root.baseKey === " " : (modelData === root.baseKey && root.baseKey !== "")))
            // Finger zone membership: tinted when this key belongs to the
            // trained finger (or to any mapped finger on combined levels).
            readonly property string finger: root.keyFingerMap[modelData] || ""
            readonly property bool inZone: finger !== "" && (root.activeFinger === "" || root.activeFinger === finger)
            readonly property color fingerColor: root.fingerColors[finger] || "transparent"

            width: (root.keyWidths[modelData] || 1) * root.keySize
            height: root.keySize
            radius: Style.cornerRadius > 0 ? Math.min(Style.cornerRadius, 6) : 4
            color: active ? (finger !== "" ? Util.alpha(fingerColor, 0.38) : Util.alpha(Color.accent, 0.28))
              : (inZone ? Util.alpha(fingerColor, 0.16) : Util.alpha(Color.foreground, 0.05))
            border.width: active || inZone ? Math.max(1, Style.space(2)) : 1
            border.color: active ? (finger !== "" ? fingerColor : Color.accent)
              : (inZone ? Util.alpha(fingerColor, 0.55) : Util.alpha(Color.foreground, 0.18))

            Behavior on color { ColorAnimation { duration: 90 } }
            Behavior on border.color { ColorAnimation { duration: 90 } }

            Text {
              anchors.centerIn: parent
              text: root.keyLabels[keyCap.modelData] || keyCap.modelData.toUpperCase()
              color: keyCap.active ? (keyCap.finger !== "" ? keyCap.fingerColor : Color.accent) : Color.muted
              font.family: Style.font.family
              font.pixelSize: keyCap.modelData.length > 1 ? Style.font.bodySmall : Style.font.body
              font.bold: keyCap.active
            }

            // Small tactile bump under F/J, same as a physical keyboard —
            // a constant visual anchor for finding home row by feel.
            Rectangle {
              visible: keyCap.isHome
              width: parent.width * 0.4
              height: Math.max(2, Style.space(2))
              radius: height / 2
              color: keyCap.active ? Color.accent : Util.alpha(Color.foreground, 0.4)
              anchors.horizontalCenter: parent.horizontalCenter
              anchors.bottom: parent.bottom
              anchors.bottomMargin: parent.height * 0.14
            }
          }
        }
      }
    }
  }
}
