// Generated by ReScript, PLEASE EDIT WITH CARE
'use strict';

var Curry = require("bs-platform/lib/js/curry.js");
var React = require("react");
var Belt_Array = require("bs-platform/lib/js/belt_Array.js");
var CountrySuggestion = require("./CountrySuggestion.bs.js");

var dataURL = "https://gist.githubusercontent.com/rusty-key/659db3f4566df459bd59c8a53dc9f71f/raw/4127f9550ef063121c564025f6d27dceeb279623/counties.json";

function CountrySelect(Props) {
  var match = React.useState(function () {
        return "";
      });
  var setQuery = match[1];
  var match$1 = React.useState(function () {
        return [];
      });
  var setSearchResult = match$1[1];
  var match$2 = React.useState(function () {
        return [];
      });
  var setAllCountries = match$2[1];
  var allCountries = match$2[0];
  var match$3 = React.useState(function () {
        return "Select a Country";
      });
  var setSelectedCountryLabel = match$3[1];
  var req = new XMLHttpRequest();
  req.open("GET", dataURL);
  req.send();
  req.addEventListener("load", (function (param) {
          var response = JSON.parse(req.response);
          var result = Belt_Array.mapWithIndex(response, (function (i, x) {
                  return {
                          id: String(i),
                          label: x.label,
                          value: x.value
                        };
                }));
          return Curry._1(setAllCountries, (function (param) {
                        return result;
                      }));
        }));
  req.addEventListener("error", (function (param) {
          console.log("Error with req from github");
          
        }));
  var onChange = function (evt) {
    evt.preventDefault();
    var value = evt.target.value;
    Curry._1(setQuery, value);
    var searchList = Belt_Array.keep(allCountries, (function (c) {
            return c.label.includes(value);
          }));
    return Curry._1(setSearchResult, (function (param) {
                  return searchList;
                }));
  };
  var countryFromChild = function (param, selectedCountryLabel) {
    return Curry._1(setSelectedCountryLabel, (function (_prev) {
                  return selectedCountryLabel;
                }));
  };
  return React.createElement("div", {
              className: "container centered"
            }, React.createElement("form", undefined, React.createElement("div", {
                      className: "row"
                    }, React.createElement("div", {
                          className: "one-third column title-centered"
                        }, React.createElement("button", undefined, match$3[0], React.createElement("i", {
                                  className: "bi-caret-down-fill caret-style"
                                })))), React.createElement("div", {
                      className: "row"
                    }, React.createElement("div", {
                          className: "input-icons autocomplete one-third column"
                        }, React.createElement("i", {
                              className: "bi-search icon"
                            }), React.createElement("input", {
                              className: "input-field",
                              id: "myInput",
                              placeholder: "Search",
                              type: "text",
                              value: match[0],
                              onKeyDown: (function ($$event) {
                                  var key = $$event.key;
                                  switch (key) {
                                    case "ArrowDown" :
                                        console.log("2");
                                        return ;
                                    case "ArrowUp" :
                                        console.log("1");
                                        return ;
                                    default:
                                      return ;
                                  }
                                }),
                              onChange: onChange
                            }), React.createElement(CountrySuggestion.make, {
                              results: match$1[0],
                              clickedValue: countryFromChild
                            })))));
}

var make = CountrySelect;

exports.dataURL = dataURL;
exports.make = make;
/* react Not a pure module */
