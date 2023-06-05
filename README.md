# Messing up with NPC dialogs?
This mod provides a easy-to-use dialog API. This mod was extracted from [the game Glitch](https://content.minetest.net/packages/Wuzzy/glitch/), a game in the 2022 Minetest Game Jam. This mod is backward-compactible with the upstream.

On top of the upstream one, this mod did the following changes:

1. `dialog.show_dialogtree` now accepts a optional `speech_id` to specity the staring speech ID.
2. `options` of [Speech definition tables](#Speech) now can be a function receiving the player object and returns a list of [options](#Option).
3. Options now align to the bottom. Previously, options align to the top.

If this mod is installed to a Glitch game, this mod's functions will replace the ones provided by the game, while keeping the dialogs.

## API
### `dialog.register_dialogtree(name, def)`
Register a dialog tree.

* `name`: The ID of the dialog tree.
* `def`: A [dialog tree definition table](#dialog-tree).

### `dialog.register_speaker(name, def)`
Register a speaker.

* `name`: The ID of the speaker.
* `def`: A [speaker defination table](#Speaker).

### `dialog.show_dialogtree(player, dialogtree_id, speech_id)`
Show a dialog tree.

* `player`: The player object of the target.
* `dialogtree_id`: The ID of the [dialog tree](#dialog-tree) to be shown.
* `speech_id` (Optional): The starting speech to be loaded. Default to `"start"` for string-indexed dialog trees or `1` to number-indexed ones. *New in 1F616EMO fork.*

## Definition table
### Speaker
A table containing informationof a speaker. Keys contain:

* `name`: A string, the display name of the speaker. It should not be formspec-escaped.
* `portrait`: A string of texture name, or a table of them, of the speaker. If it is a table, a random one will be chosen.
* `portrait_animated`: A boolean. If true, `portrait` should specify a 8-frame 16x16 (16x128) png like [the one in Glitch](https://codeberg.org/Wuzzy/Glitch/src/branch/master/mods/glitch_dialog/textures/glitch_dialog_portrait_white_noise_anim.png).

### Dialog tree
A table containing information of a dialog tree. Keys contain:

* `speeches`: A table, either number- or string-indexed, containing all the [speech definitions](#Speech). If number-indexed, the dialogs will be played one-by-one; if string-indexed, each speech mush contain at least one `options`.
* `force_stay`: A boolean. If true, dialog window is forced to stay open. Known bug: force-keeping a dialog open does not work reliably if the player spam the Esc key. Workaround: Don't have any required dialogues.
* `on_exit(player)` (Optional): A function being called when the entire dialogtree was left. Not called when the current [speech](#Speech) has its own `on_exit` function.

## Speech
A table containing information of a speech. Keys contain:

* `speaker`: A string, the ID of the [speaker](#Speaker).
* `text`: A string, the text to be spoken by the speaker in the speech. It should not be formspec-escaped.
* `on_enter(player)` (Optional): Called when this speech entered.
* `on_exit(player)` (Optional): Called when this speech exited. If present and the speech is the last one of the dialog tree, the `on_exit` function of its [dialog tree](#dialog-tree) is not called.
* `options`: Either one of the following:
    * A table containing a list of [options](#Option).
    * `function(player)`: A function receiving the current player as its parameter, and return a table containing a list of [options](#Option). *New in 1F616EMO fork.*
    * If the dialog tree is number-indexed, this key is optional, and a "Continue" option is automatically generated for the user to go to the next speech.
* `focus` (Optional): A integer, the default selection of options. Default to 1.

## Option
A table containing information of an option. Keys contain:

* `text` (Optional): A string, the text to be shown on the button. It should not be formspec-escaped.
    * Default to "Continue" for speech or "Quit" for quit. *New in 1F616EMO fork*
* `action`: A string, either one of the following:
    * `"quit"`: The dialog closes. `on_exit` callbacks of the [speech](#Speech) or the [dialog tree](#dialog-tree) are called.
    * `"speech"`: Another speech opens.
    * `"field"`: A text input. *New in 1F616EMO fork*
    * `"blank"`: Leaves a empty spacing. *New in 1F616EMO fork*
* When `action = "speech"`:
    * `dialogtree_id` (Optional): A string, the dialog tree to be searched for the [speech](#Speech). Default to the current [dialog tree](#dialog-tree). *New in 1F616EMO fork*
    * `next_speech`: A string, or a number, of the [speech](#Speech) to be shown.
* When `action = "field"`: *New in 1F616EMO fork*
    * `"name"` (Optional): The name of the field. Default to `"dialog_" .. o`, where `o` is the index of the option.
    * `"default"` (Optional): The default value of the field. Default to empty.

