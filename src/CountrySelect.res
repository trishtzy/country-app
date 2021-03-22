let dataURL = "https://gist.githubusercontent.com/rusty-key/659db3f4566df459bd59c8a53dc9f71f/raw/4127f9550ef063121c564025f6d27dceeb279623/counties.json"
type request
type response
type country = {"ID": string, "label": string, "value": string}
type countries = array<country>
@bs.new external makeXMLHttpRequest: unit => request = "XMLHttpRequest"
@bs.send external addEventListener: (request, string, unit => unit) => unit = "addEventListener"
@bs.get external response: request => response = "response"
@bs.send external open_: (request, string, string) => unit = "open"
@bs.send external send: request => unit = "send"
@bs.send external sendReq: request => unit = "send"
@bs.send external abort: request => unit = "abort"
// =========
@bs.scope("JSON") @bs.val
external parseCountryResponse: response => countries = "parse"

type document // abstract type for a document object
@bs.send external getElementById: (document, string) => Dom.element = "getElementById"
@bs.val external doc: document = "document"
@bs.send external getElementsByTagName: (Dom.element, string) => array<Dom.element> = "getElementsByTagName"
@bs.send external classList: option<Dom.element> => Dom.domTokenList = "classList"
@bs.send external add: (Dom.domTokenList, string) => unit = "add"
@bs.send external remove: (Dom.domTokenList, string) => unit = "remove"
@bs.send external childNodes: option<Dom.element> => array<Dom.element> = "childNodes"
@bs.send external firstChild: option<Dom.element> => Dom.element = "firstChild"
@bs.send external nodeValue: Dom.element => string = "nodeValue"

@react.component
let make = () => {
  let (index) = React.useRef(-1);
  let (query, setQuery) = React.useState(() => "");
  let (searchResult, setSearchResult) = React.useState(_ => []);
  let (allCountries, setAllCountries) = React.useState(_ => []);
  let (selectedCountryLabel, setSelectedCountryLabel) = React.useState(_ => "Select a Country");

  let req = makeXMLHttpRequest();
  req->open_("GET", dataURL);
  req->send
  req->addEventListener("load", () => {
    let response = req->response->parseCountryResponse
    let result = Belt.Array.mapWithIndex(response, (i, x) => {
      {"id": Belt.Int.toString(i), "label": x["label"], "value": x["value"]}
    })
    setAllCountries(_ => result)
  })
  req->addEventListener("error", () => {
    Js.log("Error with req from github")
  })

  let onChange = evt => {
    ReactEvent.Form.preventDefault(evt)
    let value = ReactEvent.Form.target(evt)["value"]
    setQuery(value)
    let searchList = Belt.Array.keep(allCountries, c => Js.String2.includes(Js.String2.toLowerCase(c["label"]), Js.String2.toLowerCase(value)))
    setSearchResult(_ => searchList)
  }
  // Js.log(esReqBody(query))

  let countryFromChild = (_, label) => {
    setSelectedCountryLabel(_prev => label)
  }

  let keyDown = (evt, key) => {
    let autoCompleteBlock = doc->getElementById("autocomplete-list")
    let autoCompleteChildren = autoCompleteBlock->getElementsByTagName("div")
    Js.log(`index: ${Belt.Int.toString(index.current)}`)
    Js.log(key)
    if (index.current > -1) {
      let countryChild = Belt.Array.get(autoCompleteChildren, index.current)
      remove(countryChild->classList, "autocomplete-active")
    }
    switch (key) {
    | "ArrowUp" => {
      if (index.current < 0) {
        index.current = 0
      } else {
        index.current = index.current - 1
      }
      Js.log(`index: ${Belt.Int.toString(index.current)}`)
      let countryChild = Belt.Array.get(autoCompleteChildren, index.current)
      add(countryChild->classList, "autocomplete-active")
    }
    | "ArrowDown" => {
      if Belt.Array.get(autoCompleteChildren, index.current + 1) != None {
        index.current = index.current + 1
      }
      Js.log(`index: ${Belt.Int.toString(index.current)}`)
      let countryChild = Belt.Array.get(autoCompleteChildren, index.current)
      add(countryChild->classList, "autocomplete-active")
    }
    | "Enter" => {
      ReactEvent.Keyboard.preventDefault(evt)
      if (index.current > -1) {
        let countryChild = Belt.Array.get(autoCompleteChildren, index.current)
        let nodes = countryChild->childNodes
        let node1 = nodes[1]
        let text = node1->firstChild->nodeValue
        setSelectedCountryLabel(_ => text)
      }
    }
    | _ => ()
    }
  }

  <div className="container centered">
    <form>
      <div className="row">
        <div className="one-third column title-centered">
        <button>
          {React.string(selectedCountryLabel)}
          <i className="bi-caret-down-fill caret-style"></i>
        </button>
        </div>
      </div>
      <div className="row">
        <div className="input-icons autocomplete one-third column">
          <i className="bi-search icon"></i>
          <input
            id="myInput"
            className="input-field"
            type_="text"
            placeholder="Search"
            onChange
            value=query
            onKeyDown={event => keyDown(event, ReactEvent.Keyboard.key(event))}/>
          <CountrySuggestion results=searchResult clickedValue={countryFromChild}/>
        </div>
      </div>
    </form>
  </div>
}
