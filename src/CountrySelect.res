let esReqBody = (q) => = {
  "query": {
    "multi_match": {
      "query": q,
      "type": "bool_prefix",
      "fields": [
        "label",
        "value",
        "label._2gram",
        "value._2gram",
        "label._3gram",
        "value._3gram"
      ]
    }
  }
}
type request
type response
type country = {"ID": int, "label": string, "value": string}
type countries = array<country>
type esHits = {_index: string, _type: string, _id: string, _score: float, _source: country}
type esInnerResponse = { hits: array<esHits> }
type esResponse = { hits: esInnerResponse }
@bs.new external makeXMLHttpRequest: unit => request = "XMLHttpRequest"
@bs.send external addEventListener: (request, string, unit => unit) => unit = "addEventListener"
@bs.get external response: request => response = "response"
@bs.send external open_: (request, string, string) => unit = "open"
@bs.send external send: (request, option<string>) => unit = "send"
@bs.send external sendReq: request => unit = "send"
@bs.send external abort: request => unit = "abort"
@bs.send external setRequestHeader: (request, string, string) => unit = "setRequestHeader"
// =========
@bs.scope("JSON") @bs.val
external parseResponse: response => esResponse = "parse"
@bs.scope("JSON") @bs.val
external parseCountryResponse: response => countries = "parse"

type document // abstract type for a document object
@bs.send external getElementById: (document, string) => Dom.element = "getElementById"
@bs.val external doc: document = "document"

@react.component
let make = () => {
  let (query, setQuery) = React.useState(() => "");
  let (searchResult, setSearchResult) = React.useState(_ => []);
  let (selectedCountryLabel, setSelectedCountryLabel) = React.useState(_ => "Select a Country");
  let onChange = evt => {
    ReactEvent.Form.preventDefault(evt)
    let value = ReactEvent.Form.target(evt)["value"]
    setQuery(value)
    // Js.log(`query: ${query} value: ${value}`)
    let esReq = makeXMLHttpRequest();
    esReq->addEventListener("load", () => {
      let response = esReq->response->parseResponse
      if Belt_Array.length(response.hits.hits) > 0 {
        let clist = Belt.Array.map(response.hits.hits, x => {
          {"id": Belt.Int.toString(x._source["ID"]), "label": x._source["label"], "value": x._source["value"]}
        })
        setSearchResult(_prev => clist)
      } else {
        setSearchResult(_prev => [])
      }
      // Js.log(response.hits.hits)
    })
    esReq->addEventListener("error", () => {
      Js.log("Error logging here esreq")
    })
    esReq->open_("POST", "http://localhost:9200/country/_search");
    esReq->setRequestHeader("Content-Type", "application/json;charset=UTF-8");
    esReq->send(Js.Json.stringifyAny(esReqBody(value)));
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
