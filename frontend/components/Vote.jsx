import React, { useEffect, useState } from "react"
import { Button } from "react-bootstrap"
import { useCanister } from "@connect2ic/react"

const Vote = () => {
  const [backendDao] = useCanister("backendDao")
  const [allProposals, setAllProposals] = useState([])
  const [proposal, setProposal] = useState("1")

  const getAllProposals = async () => {
    const allProps = await backendDao.get_all_proposals()
    console.log(allProps)
    setAllProposals(allProps.reverse())
  }

  const yeaHandler = async () => {
    try {
      let res = await backendDao.vote(proposal, true)
      console.log("Yea!")
      console.log(res)
    } catch (error) {
      console.log(error)
    }
  }
  const nayHandler = async () => {
    try {
      let res = await backendDao.vote(proposal, false)
      console.log("Nay!")
      console.log(res)
    } catch (error) {
      console.log("error")
    }
  }

  useEffect(() => {
    getAllProposals()
  }, [])

  return (
    <div className="container text-center my-5">
      <h2>Vote for a Proposal</h2>
      <input
        type="text"
        placeholder="Enter a proposal Id"
        onChange={(e) => setProposal(e.target.value)}
      />

      <div className="container d-flex justify-content-center">
        <div className="row my-2 w-25">
          <div className="col">
            <Button className="btn-primary text-light" onClick={yeaHandler}>
              Yea!
            </Button>
          </div>
          <div className="col">
            <Button className="btn-primary text-light" onClick={nayHandler}>
              Nay!
            </Button>
          </div>
        </div>
      </div>
    </div>
  )
}

export default Vote
