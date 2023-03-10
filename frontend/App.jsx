import React, { useEffect } from "react"
import logo from "./assets/dfinity.svg"
/*
 * Connect2ic provides essential utilities for IC app development
 */
import { createClient } from "@connect2ic/core"
import { defaultProviders } from "@connect2ic/core/providers"
import { ConnectDialog, Connect2ICProvider } from "@connect2ic/react"
import "@connect2ic/core/style.css"
import "bootstrap/dist/css/bootstrap.min.css"
import NavigationBar from "./components/NavigationBar"
import { useBalance, useWallet } from "@connect2ic/react"

/*
 * Import canister definitions like this:
 */
// import * as counter from "../.dfx/local/canisters/counter"
import * as backendDao from "../.dfx/local/canisters/backendDao"
import * as webPage from "../.dfx/local/canisters/webpage"

/*
 * Some examples to get you started
 */

import { AllProposals } from "./components/AllProposals"
import HomePage from "./components/HomePage"
import { BrowserRouter, Redirect, Route, Switch } from "react-router-dom"
import Vote from "./components/Vote"
import NewProposal from "./components/NewProposal"

function App() {
  const [wallet] = useWallet()
  const [assets] = useBalance()

  useEffect(() => {
    document.title = "DAO"
  }, [])

  return (
    <BrowserRouter>
      {<NavigationBar wallet={wallet} />}
      <div>
        {/* <SideBar /> */}
        <div className="App">
          <ConnectDialog />
        </div>
        <Switch>
          <Route path="/" exact>
            <HomePage />
          </Route>
          {wallet && (
            <Route path="/proposals" exact>
              <AllProposals />
            </Route>
          )}
          {wallet && (
            <Route path="/vote" exact>
              <Vote />
            </Route>
          )}
          {wallet && (
            <Route path="/new-proposal" exact>
              <NewProposal />
            </Route>
          )}
          <Redirect to="/" />
        </Switch>
      </div>
    </BrowserRouter>
  )
}

const client = createClient({
  canisters: {
    backendDao,
    webPage,
  },
  providers: defaultProviders,
  globalProviderConfig: {
    dev: import.meta.env.DEV,
  },
})

export default () => (
  <Connect2ICProvider client={client}>
    <App />
  </Connect2ICProvider>
)
