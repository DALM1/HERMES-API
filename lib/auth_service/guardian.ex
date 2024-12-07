defmodule AuthService.Guardian do
  use Guardian, otp_app: :auth_service

  def subject_for_token(user, _claims) do
    {:ok, to_string(user.id)}
  end

  def resource_from_claims(claims) do
    id = claims["sub"]
    {:ok, %{id: id}} # Remplacez par une recherche DB si nécessaire
  end
end
