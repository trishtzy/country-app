type country = {id: int, label: string, value: string}

@react.component
let make = (~results) => {
  let options = Belt.Array.map(results, country => {
    <li key={country.value}>
      {React.string(country.label)}
    </li>
  })
  <div className="container">
    <ul>
      {React.array(options)}
    </ul>
  </div>
}
