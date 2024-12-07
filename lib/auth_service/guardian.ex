defmodule AuthService.Guardian do
  use Guardian, otp_app: :auth_service

  alias AuthService.Repo
  alias AuthService.Auth.User

  @spec subject_for_token(User.t(), any()) :: {:ok, String.t()} | {:error, String.t()}
  def subject_for_token(%User{id: id}, _claims) do
    {:ok, to_string(id)}
  end

  def subject_for_token(_, _), do: {:error, "Impossible de générer un token"}

  @spec resource_from_claims(map()) :: {:ok, User.t()} | {:error, String.t()}
  def resource_from_claims(%{"sub" => id}) do
    case Repo.get(User, id) do
      nil -> {:error, "Utilisateur introuvable"}
      user -> {:ok, user}
    end
  end

  def resource_from_claims(_), do: {:error, "Claims invalides"}
end
