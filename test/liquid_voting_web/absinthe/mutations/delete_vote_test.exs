defmodule LiquidVotingWeb.Absinthe.Mutations.DeleteVoteTest do
  use LiquidVotingWeb.ConnCase
  import LiquidVoting.Factory

  alias LiquidVotingWeb.Schema.Schema

  describe "delete vote" do
    setup do
      vote = insert(:vote)
      result = insert(:voting_result, in_favor: 1, proposal_url: vote.proposal_url)

      [
        participant_email: vote.participant.email,
        proposal_url: vote.proposal_url,
        organization_id: vote.organization_id,
        result: result
      ]
    end

    test "with a participant's email and proposal_url", context do
      query = """
      mutation {
        deleteVote(participantEmail: "#{context[:participant_email]}", proposalUrl:"#{
        context[:proposal_url]
      }") {
          participant {
            email
          }
          votingResult {
            in_favor
            against
          }
        }
      }
      """

      {:ok, %{data: %{"deleteVote" => vote}}} =
        Absinthe.run(query, Schema, context: %{organization_id: context[:organization_id]})

      assert vote["participant"]["email"] == context[:participant_email]
      assert vote["votingResult"]["in_favor"] == 0
      assert vote["votingResult"]["against"] == 0
    end

    test "when vote doesn't exist", context do
      another_participant = insert(:participant, organization_id: context[:organization_id])

      query = """
      mutation {
        deleteVote(participantEmail: "#{another_participant.email}", proposalUrl:"#{
        context[:proposal_url]
      }") {
          participant {
            email
          }
        }
      }
      """

      {:ok, %{errors: [%{message: message}]}} =
        Absinthe.run(query, Schema, context: %{organization_id: context[:organization_id]})

      assert message == "No vote found to delete"
    end
  end
end
