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
  let (query, setQuery) = React.useState(_ => "");
  let (countryList, setCountryList) = React.useState(_ => []);
  let (allCountries, setAllCountries) = React.useState(_ => []);

  let onChange = evt => {
    ReactEvent.Form.preventDefault(evt)
    let value = ReactEvent.Form.target(evt)["value"]
    setQuery(_prev => value);
    let esReq = makeXMLHttpRequest();
    esReq->addEventListener("load", () => {
      let response = esReq->response->parseResponse
      if Belt_Array.length(response.hits.hits) > 0 {
        let clist = Belt.Array.map(response.hits.hits, x => {
          {"id": Belt.Int.toString(x._source["ID"]), "label": x._source["label"], "value": x._source["value"]}
        })
        setCountryList(_prev => clist)
      }
      // Js.log(response.hits.hits)
    })
    esReq->addEventListener("error", () => {
      Js.log("Error logging here esreq")
    })
    esReq->open_("POST", "http://localhost:9200/country/_search");
    esReq->setRequestHeader("Content-Type", "application/json;charset=UTF-8");
    esReq->send(Js.Json.stringifyAny(esReqBody(query)));
  }
  // Js.log(esReqBody(query))
  let keyDown = key => {
    switch (key) {
    | "ArrowUp" => Js.log("1")
    | "ArrowDown" => Js.log("2")
    | _ => ()
    }
  }

  let countryReq = makeXMLHttpRequest();
  countryReq->addEventListener("load", () => {
    let response = countryReq->response->parseCountryResponse
    let allCountries = Belt.Array.map(response, x => {
          {"id": Belt.Int.toString(x["ID"]), "label": x["label"], "value": x["value"]}
        })
    setAllCountries(_prev => allCountries)
  })
  countryReq->addEventListener("error", () => {
    Js.log("Error logging here countryReq")
  })
  countryReq->open_("GET", "http://localhost:8080/countries")
  countryReq->sendReq

  let allCountriesOptions = Belt.Array.map(allCountries, country => {
      <option key={country["id"]} value={country["value"]}>{React.string(country["label"])}</option>
    })
  <div className="container centered">
    <form>
      <div className="row">
        <div className="one-third column title-centered">
          <select id="exampleRecipientInput">
            <option value="Option 1">{React.string("United States")}</option>
            {React.array(allCountriesOptions)}
          </select>
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
          <CountrySuggestion results=countryList/>
        </div>
      </div>
    </form>
  </div>
}
