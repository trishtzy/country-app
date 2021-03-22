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

@react.component
let make = () => {
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
    let searchList = Belt.Array.keep(allCountries, c => Js.String2.includes(c["label"], value))
    setSearchResult(_ => searchList)
  }
  // Js.log(esReqBody(query))
  let keyDown = key => {
    switch (key) {
    | "ArrowUp" => Js.log("1")
    | "ArrowDown" => Js.log("2")
    | _ => ()
    }
  }

  let countryFromChild = (_, selectedCountryLabel) => {
    setSelectedCountryLabel(_prev => selectedCountryLabel)
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
            onKeyDown={event => keyDown(ReactEvent.Keyboard.key(event))}/>
          <CountrySuggestion results=searchResult clickedValue={countryFromChild}/>
        </div>
      </div>
    </form>
  </div>
}
