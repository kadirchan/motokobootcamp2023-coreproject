import Int "mo:base/Int";
import Nat "mo:base/Nat";
import Time "mo:base/Time";
import Text "mo:base/Text";
import Iter "mo:base/Iter";
import Array "mo:base/Array";
import Result "mo:base/Result";
import Buffer "mo:base/Buffer";
import Option "mo:base/Option";
import HashMap "mo:base/HashMap";
import Principal "mo:base/Principal";

actor {

    stable var proposalCount = 1;
    // proposal structure
    public type Proposal = {
        proposalID : Text;
        proposalOwner : Text;
        proposalText : Text;
        yeaCount : Nat;
        nayCount : Nat;
        isActive : Bool;
        initTime : Text;
        endTime : Text;
        voters : [Text]
    };

    // minimum power for voting
    stable let minimumRequirement = 100000000;

    // threshold for accept or reject
    stable let powerThreshold = 10000000000;

    // our controlled webpage canister
    let WebpageCanister = actor ("dvgwt-taaaa-aaaag-qbr2a-cai") : actor {
        setNewText : (newText : Text) -> async ()
    };

    // account for icrc1 token standart
    public type ICRC1_Account = { owner : Principal; subaccount : ?[Nat8] };

    // our mbtoken canister
    let TokenCanister = actor ("db3eq-6iaaa-aaaah-abz6a-cai") : actor {
        icrc1_balance_of : (account : ICRC1_Account) -> async Nat
    };

    // our proposal map
    stable var proposals : [(Text, Proposal)] = [];

    // for upgrade
    var proposalsMap = HashMap.fromIter<Text, Proposal>(proposals.vals(), 100000, Text.equal, Text.hash);

    private func getVotePower(account : Principal) : async Nat {
        return await TokenCanister.icrc1_balance_of({
            owner = account;
            subaccount = null
        })
    };

    private func isVoted(array : [Text], principal : Text) : Bool {
        for (val in array.vals()) {
            if (Text.equal(principal, val)) {
                return true
            }
        };
        return false
    };

    public shared query func get_proposal(proposalId : Text) : async Result.Result<Proposal, Text> {
        switch (proposalsMap.get(proposalId)) {
            case (null) {
                return #err("Proposal not exist :(")
            };
            case (?proposal) {
                return #ok(proposal)
            }
        }
    };

    public shared ({ caller }) func submit_proposal(text : Text) : async Result.Result<Proposal, Text> {
        if (Nat.greater(text.size(), 100) or Nat.equal(text.size(), 0)) {
            return #err("Text should be between 1-100 characters!")
        };
        let votePower = await getVotePower(caller);
        let proposal : Proposal = {
            proposalID = Nat.toText(proposalCount);
            proposalOwner = Principal.toText(caller);
            proposalText = text;
            yeaCount = votePower;
            nayCount = 0;
            isActive = true;
            initTime = Int.toText(Time.now());
            endTime = Int.toText(Time.now());
            voters = [Principal.toText(caller)]
        };
        proposalsMap.put(Nat.toText(proposalCount), proposal);
        proposalCount := proposalCount +1;
        return #ok(proposal)
    };

    public shared query func get_all_proposals() : async [Proposal] {
        var proposalBuffer = Buffer.Buffer<Proposal>(0);
        for (proposalID in proposalsMap.keys()) {
            switch (proposalsMap.get(proposalID)) {
                case (null) {};
                case (?proposal) {
                    proposalBuffer.add(proposal)
                }
            };

        };
        return proposalBuffer.toArray()
    };

    public shared ({ caller }) func vote(proposalId : Text, isAccepted : Bool) : async Result.Result<Proposal, Text> {
        let votePower = await getVotePower(caller);
        // let votePower = 1000000000;
        if (votePower < minimumRequirement) {
            return #err("You cannot vote with this token amount.")
        };
        switch (proposalsMap.get(proposalId)) {
            case (null) {
                return #err("Proposal not exist.")
            };
            case (?proposal) {
                if (not proposal.isActive) {
                    return #err("Proposal ended.")
                };
                if (isVoted(proposal.voters, Principal.toText(caller))) {
                    return #err("You already voted.")
                };
                let updatedVoters = Array.append(proposal.voters, [Principal.toText(caller)]);
                if (isAccepted) {
                    let updatedYeas = proposal.yeaCount + votePower;
                    let updatedProposal = {
                        proposalID = proposal.proposalID;
                        proposalOwner = proposal.proposalOwner;
                        proposalText = proposal.proposalText;
                        yeaCount = updatedYeas;
                        nayCount = proposal.nayCount;
                        isActive = true;
                        initTime = proposal.initTime;
                        endTime = proposal.endTime;
                        voters = updatedVoters
                    };
                    proposalsMap.put(proposalId, updatedProposal)
                } else {
                    let updatedNay = proposal.nayCount + votePower;
                    let updatedProposal = {
                        proposalID = proposal.proposalID;
                        proposalOwner = proposal.proposalOwner;
                        proposalText = proposal.proposalText;
                        yeaCount = proposal.yeaCount;
                        nayCount = updatedNay;
                        isActive = true;
                        initTime = proposal.initTime;
                        endTime = proposal.endTime;
                        voters = updatedVoters
                    };
                    proposalsMap.put(proposalId, updatedProposal)
                };
                return #ok(proposal)
            }
        }
    };
    public shared func checkExecuteProposals() : async () {
        var activeProposalBuffer = Buffer.Buffer<Proposal>(0);
        for (proposalID in proposalsMap.keys()) {
            switch (proposalsMap.get(proposalID)) {
                case (null) {};
                case (?proposal) {
                    if (proposal.isActive) {
                        activeProposalBuffer.add(proposal)
                    }
                }
            }
        };

        for (proposal in activeProposalBuffer.vals()) {

            if (proposal.yeaCount >= powerThreshold) {
                let time = Int.toText(Time.now());
                let updatedProposal = {
                    proposalID = proposal.proposalID;
                    proposalOwner = proposal.proposalOwner;
                    proposalText = proposal.proposalText;
                    yeaCount = proposal.yeaCount;
                    nayCount = proposal.nayCount;
                    isActive = false;
                    initTime = proposal.initTime;
                    endTime = time;
                    voters = proposal.voters
                };
                proposalsMap.put(proposal.proposalID, updatedProposal);
                await WebpageCanister.setNewText(proposal.proposalText);
                return
            } else if (proposal.nayCount >= powerThreshold) {
                let time = Int.toText(Time.now());
                let updatedProposal = {
                    proposalID = proposal.proposalID;
                    proposalOwner = proposal.proposalOwner;
                    proposalText = proposal.proposalText;
                    yeaCount = proposal.yeaCount;
                    nayCount = proposal.nayCount;
                    isActive = false;
                    initTime = proposal.initTime;
                    endTime = time;
                    voters = proposal.voters
                };
                proposalsMap.put(proposal.proposalID, updatedProposal);
                return
            }
        }
    };

    system func preupgrade() {
        proposals := Iter.toArray(proposalsMap.entries())
    };

    system func postupgrade() {
        proposals := []
    };
    system func heartbeat() : async () {
        await checkExecuteProposals()
    }
}
