@module external flagSVG: string = "../assets/US.svg";

@react.component
let make = (~results, ~clickedValue) => {

  let handleClick = selectedCountry => {
    let value = selectedCountry["value"]
    let label = selectedCountry["label"]
    clickedValue(value, label)
    Js.log(value)
  }
  let options = Belt.Array.map(results, country => {
    <div onClick={_ => handleClick(country)} className="flag-option" key=`country-${country["id"]}`>
      <img className="flag-icon" alt="United States" src={flagSVG}/>
      <span className="option-field">{React.string(country["label"])}</span>
      <input key=`country-input-${country["id"]}` type_="hidden" value={country["value"]}/>
    </div>
  })
  <div id="autocomplete-list" className="row autocomplete-items">
    {React.array(options)}
  </div>
}
