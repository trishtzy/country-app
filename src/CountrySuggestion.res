@react.component
let make = (~results) => {
  let options = Belt.Array.map(results, country => {
    <div className="flag-option" key=`country-${country["id"]}`>
      <img className="flag-icon" alt="United States" src="http://purecatamphetamine.github.io/country-flag-icons/3x2/US.svg"/>
      <span className="option-field">{React.string(country["label"])}</span>
      <input key=`country-input-${country["id"]}` type_="hidden" value={country["value"]}/>
    </div>
  })
  <div id="autocomplete-list" className="row autocomplete-items">
    {React.array(options)}
  </div>
}
