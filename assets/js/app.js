// Brunch automatically concatenates all files in your
// watched paths. Those paths can be configured at
// config.paths.watched in "brunch-config.js".
//
// However, those files will only be executed if
// explicitly imported. The only exception are files
// in vendor, which are never wrapped in imports and
// therefore are always executed.

// Import dependencies
//
// If you no longer want to use a dependency, remember
// to also remove its path from "config.paths.watched".
import "phoenix_html"
import socket from "./socket"

const acorn = [
                {x: 1, y: 0},
                                             {x: 3, y: 1},
  {x: 0, y: 2}, {x: 1, y: 2},                              {x: 4, y: 2}, {x: 5, y: 2}, {x: 6, y: 2}
]

const pentadecathalon = [
  {x: 0, y: 1},  {x: 1, y: 1},  {x: 2, y: 1},
                 {x: 1, y: 2},
                 {x: 1, y: 3},
  {x: 0, y: 4},  {x: 1, y: 4},  {x: 2, y: 4},

  {x: 0, y: 6},  {x: 1, y: 6},  {x: 2, y: 6},
  {x: 0, y: 7},  {x: 1, y: 7},  {x: 2, y: 7},

  {x: 0, y: 9},  {x: 1, y: 9},  {x: 2, y: 9},
                 {x: 1, y: 10},
                 {x: 1, y: 11},
  {x: 0, y: 12}, {x: 1, y: 12}, {x: 2, y: 12}
]

let channel = socket.channel("game_of_life", {
  "initial_state": acorn
})
channel.join()
  .receive("ok", resp => { console.log("Joined successfully", resp) })
  .receive("error", resp => { console.log("Unable to join", resp) })

setInterval(() => {
channel.push("tick", {})
  .receive("ok", ({board_state}) => {
    var board_state_el = document.getElementById("board-state")
    board_state_el.innerText = board_state
  })
}, 100)

// Import local files
//
// Local files can be imported directly using relative
// paths "./socket" or full ones "web/static/js/socket".

