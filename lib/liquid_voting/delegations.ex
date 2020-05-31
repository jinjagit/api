defmodule LiquidVoting.Delegations do
  @moduledoc """
  The Delegations context.
  """

  import Ecto.Query, warn: false
  alias LiquidVoting.Repo

  alias LiquidVoting.Delegations.Delegation

  @doc """
  Returns the list of delegations for an organization uuid

  ## Examples

      iex> list_delegations("a6158b19-6bf6-4457-9d13-ef8b141611b4")
      [%Delegation{}, ...]

  """
  def list_delegations(organization_uuid) do
    Delegation
    |> where(organization_uuid: ^organization_uuid)
    |> Repo.all
    |> Repo.preload([:delegator,:delegate])
  end

  @doc """
  Gets a single delegation for an organization uuid

  Raises `Ecto.NoResultsError` if the Delegation does not exist.

  ## Examples

      iex> get_delegation!(123, "a6158b19-6bf6-4457-9d13-ef8b141611b4")
      %Delegation{}

      iex> get_delegation!(456, "a6158b19-6bf6-4457-9d13-ef8b141611b4")
      ** (Ecto.NoResultsError)

  """
  def get_delegation!(id, organization_uuid) do
    Delegation
    |> Repo.get_by!(id: id, organization_uuid: organization_uuid)
    |> Repo.preload([:delegator,:delegate])
  end

  @doc """
  Creates a delegation.

  ## Examples

      iex> create_delegation(%{field: value})
      {:ok, %Delegation{}}

      iex> create_delegation(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_delegation(attrs \\ %{}) do
    %Delegation{}
    |> Delegation.changeset(attrs)
    |> Repo.insert()
  end

  def create_delegation!(attrs \\ %{}) do
    %Delegation{}
    |> Delegation.changeset(attrs)
    |> Repo.insert
  end

  @doc """
  Updates a delegation.

  ## Examples

      iex> update_delegation(delegation, %{field: new_value})
      {:ok, %Delegation{}}

      iex> update_delegation(delegation, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_delegation(%Delegation{} = delegation, attrs) do
    delegation
    |> Delegation.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a Delegation.

  ## Examples

      iex> delete_delegation(delegation)
      {:ok, %Delegation{}}

      iex> delete_delegation(delegation)
      {:error, %Ecto.Changeset{}}

  """
  def delete_delegation(%Delegation{} = delegation) do
    Repo.delete(delegation)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking delegation changes.

  ## Examples

      iex> change_delegation(delegation)
      %Ecto.Changeset{source: %Delegation{}}

  """
  def change_delegation(%Delegation{} = delegation) do
    Delegation.changeset(delegation, %{})
  end
end