%%raw(`import "../style/normalize.css"
import "../style/skeleton.css"`
)

switch(ReactDOM.querySelector("#root")){
| Some(root) => ReactDOM.render(<App/>, root)
| None => () // do nothing
}
