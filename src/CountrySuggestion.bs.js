// Generated by ReScript, PLEASE EDIT WITH CARE
'use strict';

var React = require("react");
var Belt_Array = require("bs-platform/lib/js/belt_Array.js");

function CountrySuggestion(Props) {
  var results = Props.results;
  var options = Belt_Array.map(results, (function (country) {
          return React.createElement("div", undefined, country.label, React.createElement("input", {
                          type: "hidden",
                          value: country.value
                        }));
        }));
  return React.createElement("div", {
              className: "row autocomplete-items",
              id: "autocomplete-list"
            }, options);
}

var make = CountrySuggestion;

exports.make = make;
/* react Not a pure module */
