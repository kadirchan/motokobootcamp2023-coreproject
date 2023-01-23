import React from "react"
import Card from "react-bootstrap/Card"
import ProgressBar from "react-bootstrap/ProgressBar"

const ProposalCard = ({ item }) => {
  const yeaCount = parseInt(item.yeaCount) / 100000000
  const nayCount = parseInt(item.nayCount) / 100000000

  let status
  let result
  let initTime = new Date(+item.initTime / 1000000)
  let endTime = new Date(+item.endTime / 1000000)
  let initTimeFormatted = formatDate(initTime)

  if (item.isActive) {
    status = "Active"
    result = "N/A"
  } else {
    status = "Ended"
    result = formatDate(endTime)
  }

  function formatDate(date) {
    var d = new Date(date),
      month = "" + (d.getMonth() + 1),
      day = "" + d.getDate(),
      year = d.getFullYear()

    if (month.length < 2) month = "0" + month
    if (day.length < 2) day = "0" + day

    return (
      [year, month, day].join("-") +
      " " +
      date.getHours() +
      ":" +
      date.getMinutes() +
      ":" +
      date.getSeconds()
    )
  }

  return (
    <Card className="w-100 child my-2">
      <Card.Body>
        <Card.Title>#{item.proposalID}</Card.Title>
        <div className="container">
          <div className="row my-2">
            <div className="col">
              <Card.Subtitle className="mb-2 text-muted">
                Status: {status}
              </Card.Subtitle>
            </div>
            <div className="col">
              <Card.Subtitle className="mb-2 text-muted">
                Proposer: {item.proposalOwner}
              </Card.Subtitle>
            </div>
          </div>
        </div>
        <Card.Text className="text-center">
          <b>Proposal Text: </b> {item.proposalText}
        </Card.Text>
        <Card.Text> Yea</Card.Text>
        <ProgressBar className="my-3">
          <ProgressBar
            animated
            variant="success"
            now={yeaCount}
            key={1}
            label={yeaCount}
          />
        </ProgressBar>
        <Card.Text> Nay</Card.Text>
        <ProgressBar>
          <ProgressBar
            animated
            variant="danger"
            now={nayCount}
            key={1}
            label={nayCount}
          />
        </ProgressBar>
        <Card.Text>Proposal Date: {initTimeFormatted}</Card.Text>
        <Card.Text>Result Date: {result}</Card.Text>
      </Card.Body>
    </Card>
  )
}

export default ProposalCard
