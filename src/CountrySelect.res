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
// bindings can be isolated/upstreamed. I'm inlining it just for the example
type request
type response
type country = {id: int, label: string, value: string}
type countries = array<country>
@bs.new external makeXMLHttpRequest: unit => request = "XMLHttpRequest"
@bs.send external addEventListener: (request, string, unit => unit) => unit = "addEventListener"
@bs.get external response: request => response = "response"
@bs.send external open_: (request, string, string) => unit = "open"
@bs.send external send: (request, option<string>) => unit = "send"
@bs.send external abort: request => unit = "abort"
@bs.send external setRequestHeader: (request, string, string) => unit = "setRequestHeader"
// =========
@bs.scope("JSON") @bs.val
external parseResponse: response => countries = "parse"

// type esResponseBody = {
//   took: int,
//   timed_out: boolean,
//   hits: {
//     hits: array<string>
//   }
// }
@react.component
let make = () => {
  let (query, setQuery) = React.useState(_ => "");
  let (countryList, setCountryList) = React.useState(_ => []);

  let onChange = evt => {
    ReactEvent.Form.preventDefault(evt)
    let value = ReactEvent.Form.target(evt)["value"]
    setQuery(_prev => value);
  }
  Js.log(esReqBody(query))

  let esReq = makeXMLHttpRequest();
  esReq->addEventListener("load", () => {
    let response = esReq->response
    Js.log(response)
  })
  esReq->addEventListener("error", () => {
    Js.log("Error logging here esreq")
  })
  esReq->open_("POST", "http://localhost:9200/test/_search");
  esReq->setRequestHeader("Content-Type", "application/json;charset=UTF-8");
  esReq->send(Js.Json.stringifyAny(esReqBody(query)));

  <div className="container centered">
    <form>
      <div className="row">
        <h5> { React.string("Country Search") } </h5>

        <div className="input-icons">
          <i className="bi-search icon"></i>
          <input className="input-field" type_="text" placeholder="Search..." onChange value=query/>
        </div>

        <p> {React.string(query)} </p>
      </div>
      <div className="row">
        <CountrySuggestion results=countryList/>
      </div>
    </form>
  </div>
}
