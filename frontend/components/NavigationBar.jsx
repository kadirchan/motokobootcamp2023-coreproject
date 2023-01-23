import Container from "react-bootstrap/Container"
import Nav from "react-bootstrap/Nav"
import Navbar from "react-bootstrap/Navbar"
import { ConnectButton } from "@connect2ic/react"
import React from "react"
import { NavLink } from "react-router-dom"

const NavigationBar = ({ wallet }) => {
  return (
    <>
      <Navbar bg="primary" variant="dark" className="py-4 sticky-top">
        <Container>
          <Navbar.Brand>
            <NavLink
              to="/"
              className="ml-auto font-weight-bold text-light navBrand"
              style={{ textDecoration: "none" }}
            >
              Motoko Bootcamp DAO
            </NavLink>
          </Navbar.Brand>
          {wallet && (
            <Nav className="me-auto">
              <Nav.Link>
                <NavLink
                  activeClassName="is-active"
                  to="/proposals"
                  className="non-active text-light"
                  style={{ textDecoration: "none" }}
                >
                  View All Proposals
                </NavLink>
              </Nav.Link>
              <Nav.Link>
                <NavLink
                  activeClassName="is-active"
                  to="/vote"
                  className="non-active text-light"
                  style={{ textDecoration: "none" }}
                >
                  Vote
                </NavLink>
              </Nav.Link>
              <Nav.Link>
                <NavLink
                  activeClassName="is-active"
                  to="/new-proposal"
                  className="non-active text-light"
                  style={{ textDecoration: "none" }}
                >
                  New Proposal
                </NavLink>
              </Nav.Link>
              <Nav.Link
                href="https://dvgwt-taaaa-aaaag-qbr2a-cai.raw.ic0.app/"
                target="_blank"
                className="mx-3 text-light"
              >
                Our WebPage!
              </Nav.Link>
            </Nav>
          )}

          {!wallet && (
            <Nav className="me-auto">
              <Nav.Link className="text-light">
                Please connect your wallet
              </Nav.Link>
            </Nav>
          )}
          <ConnectButton
            dark={false}
            style={{ backgroundColor: "white", color: "#0275d8" }}
          />
        </Container>
      </Navbar>
      <br />
    </>
  )
}

export default NavigationBar
