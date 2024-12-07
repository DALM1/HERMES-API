defmodule AuthService.Auth.User do
  use Ecto.Schema
  import Ecto.Changeset

  # Placez @derive ici, avant toute autre déclaration
  @derive {Jason.Encoder, only: [:id, :name, :email, :inserted_at, :updated_at]}

  schema "users" do
    field :name, :string
    field :email, :string
    field :password_hash, :string
    field :password, :string, virtual: true
    timestamps(type: :utc_datetime)
  end

  def changeset(user, attrs) do
    user
    |> cast(attrs, [:name, :email, :password])
    |> validate_required([:name, :email, :password])
    |> validate_format(:email, ~r/@/, message: "L'email doit avoir un format valide.")
    |> validate_length(:password, min: 6, message: "Le mot de passe doit contenir au moins 6 caractères.")
    |> hash_password()
  end

  defp hash_password(changeset) do
    case get_change(changeset, :password) do
      nil -> changeset
      password -> put_change(changeset, :password_hash, Argon2.hash_pwd_salt(password))
    end
  end
end
