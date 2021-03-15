// Generated by ReScript, PLEASE EDIT WITH CARE
'use strict';

var Curry = require("bs-platform/lib/js/curry.js");
var React = require("react");
var Belt_Array = require("bs-platform/lib/js/belt_Array.js");
var CountrySuggestion = require("./CountrySuggestion.bs.js");

function esReqBody(q) {
  return {
          query: {
            multi_match: {
              query: q,
              type: "bool_prefix",
              fields: [
                "label",
                "value",
                "label._2gram",
                "value._2gram",
                "label._3gram",
                "value._3gram"
              ]
            }
          }
        };
}

function CountrySelect(Props) {
  var match = React.useState(function () {
        return "";
      });
  var setQuery = match[1];
  var query = match[0];
  var match$1 = React.useState(function () {
        return [];
      });
  var setCountryList = match$1[1];
  var onChange = function (evt) {
    evt.preventDefault();
    var value = evt.target.value;
    Curry._1(setQuery, (function (_prev) {
            return value;
          }));
    var esReq = new XMLHttpRequest();
    esReq.addEventListener("load", (function (param) {
            var response = JSON.parse(esReq.response);
            if (response.hits.hits.length === 0) {
              return ;
            }
            var clist = Belt_Array.map(response.hits.hits, (function (x) {
                    return {
                            id: String(x._source.ID),
                            label: x._source.label,
                            value: x._source.value
                          };
                  }));
            return Curry._1(setCountryList, (function (_prev) {
                          return clist;
                        }));
          }));
    esReq.addEventListener("error", (function (param) {
            console.log("Error logging here esreq");
            
          }));
    esReq.open("POST", "http://localhost:9200/country/_search");
    esReq.setRequestHeader("Content-Type", "application/json;charset=UTF-8");
    esReq.send(JSON.stringify(esReqBody(query)));
    
  };
  return React.createElement("div", {
              className: "container centered"
            }, React.createElement("form", undefined, React.createElement("div", {
                      className: "row"
                    }, React.createElement("h5", undefined, "Country Search: ", query), React.createElement("div", {
                          className: "input-icons autocomplete"
                        }, React.createElement("i", {
                              className: "bi-search icon"
                            }), React.createElement("input", {
                              className: "input-field",
                              id: "myInput",
                              placeholder: "Search...",
                              type: "text",
                              value: query,
                              onChange: onChange
                            }), React.createElement(CountrySuggestion.make, {
                              results: match$1[0]
                            })))));
}

var make = CountrySelect;

exports.esReqBody = esReqBody;
exports.make = make;
/* react Not a pure module */
