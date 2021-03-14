%%raw(`import "../style/normalize.css"
import "../style/skeleton.css"
import "../style/countryselect.css"`
)

switch(ReactDOM.querySelector("#root")){
| Some(root) => ReactDOM.render(<App/>, root)
| None => () // do nothing
}
