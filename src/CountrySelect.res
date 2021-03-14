@react.component
let make = (~query: string) => {
  <form>
    <h2> { React.string("Country App") } </h2>
    <input placeholder="Search..."/>
    { React.string(query) }
  </form>
}
