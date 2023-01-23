import React, { useState } from "react"
import logo from ".././assets/dfinity.svg"

const HomePage = () => {
  return (
    <header className="App-header container w-75">
      <img src={logo} className="App-logo" alt="logo" />
      <p className="slogan">Motoko Bootcamp Core Project</p>
      <p className="fs-3">Kadircan Bozkurt - Düldül Osman#3240</p>
    </header>
  )
}

export default HomePage
