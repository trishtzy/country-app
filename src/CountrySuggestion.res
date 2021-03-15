type country = {id: int, label: string, value: string}

@react.component
let make = (~results) => {
  let options = Belt.Array.map(results, country => {
    <div>
      {React.string(country.label)}
      <input type_="hidden" value={country.value}/>
    </div>
  })
  <div id="autocomplete-list" className="row autocomplete-items">
    {React.array(options)}
  </div>
}
