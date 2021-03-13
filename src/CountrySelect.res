module FormControl = {
    @bs.module("react-bootstrap/FormControl")
    @react.component
    external make: (~placeholder: string) => React.element = "default"
}

@react.component
let make = (~query: string) => {
  <div>
    <FormControl placeholder="Search..."/>
  </div>
}
