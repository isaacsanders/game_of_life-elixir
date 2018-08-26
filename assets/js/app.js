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
import * as d3 from "d3"

const scale = 5

const acorn = [
                {x: 1, y: 0},
                                             {x: 3, y: 1},
  {x: 0, y: 2}, {x: 1, y: 2},                              {x: 4, y: 2}, {x: 5, y: 2}, {x: 6, y: 2}
]

const block = [
  {x: 0, y: 0}, {x: 1, y: 0},
  {x: 0, y: 1}, {x: 1, y: 1}
]

const faulty_test = [
  {x: 0, y: 0}, {x: 1, y: 0},                                           {x: 7, y: 0}, {x: 8, y: 0},
  {x: 0, y: 1}, {x: 1, y: 1},                                           {x: 7, y: 1}, {x: 8, y: 1},


                                            {x: 4, y: 4},
                                            {x: 4, y: 5},
                                            {x: 4, y: 6},


  {x: 0, y: 9}, {x: 1, y: 9},                                             {x: 7, y: 9}, {x: 8, y: 9},
  {x: 0, y: 10}, {x: 1, y: 10},                                           {x: 7, y: 10}, {x: 8, y: 10},
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

document.addEventListener("DOMContentLoaded", (event) => {
  let channel = socket.channel("game_of_life", {
    "initial_state": acorn
  })

  channel.join()
    .receive("ok", resp => { console.log("Joined successfully", resp) })
    .receive("error", resp => { console.log("Unable to join", resp) })

  // d3.select("svg")
  //   .selectAll("rect")
  //   .data(acorn)
  //   .enter().append("rect")
  //   .attr("x", ({x}) => (x * 10))
  //   .attr("y", ({y}) => (y * 10))
  //   .attr("width", "10px")
  //   .attr("height", "10px")
  //   .attr("fill", "black")

  setInterval(() => {
    channel.push("tick", {}).receive("ok", ({bounds, board_state}) => {
      var {left, top, right, bottom} = bounds

      var svg = d3.select("svg")
        .attr("viewBox", `0 0 ${right - left + 1} ${bottom - top + 1}`)

      var rects = svg
      .selectAll("rect")
      .data(board_state)
      .attr("x", ({x}) => (x))
      .attr("y", ({y}) => (y))
      .attr("width", "1px")
      .attr("height", "1px")
      .attr("fill", "black")

      rects
      .enter().append("rect")
      rects
      .exit().remove()
    })
  }, 100)

})
