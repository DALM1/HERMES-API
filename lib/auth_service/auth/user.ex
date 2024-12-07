defmodule AuthService.Auth.User do
  use Ecto.Schema
  import Ecto.Changeset

  @derive {Jason.Encoder, only: [:id, :name, :email, :role, :inserted_at, :updated_at]}

  schema "users" do
    field :name, :string
    field :email, :string
    field :password_hash, :string
    field :password, :string, virtual: true
    field :role, :string, default: "user" # Assurez-vous que le champ est bien inclus

    timestamps(type: :utc_datetime)
  end

  def changeset(user, attrs) do
    user
    |> cast(attrs, [:name, :email, :password, :role])
    |> validate_required([:name, :email, :password])
    |> validate_inclusion(:role, ["user", "admin"], message: "⚠️ Le rôle doit être 'user' ou 'admin'.")
    |> validate_format(:email, ~r/@/, message: "⚠️ L'email doit avoir un format valide.")
    |> validate_length(:password, min: 6, message: "⚠️ Le mot de passe doit contenir au moins 6 caractères.")
    |> unique_constraint(:email, message: "⚠️ Cet email est déjà utilisé.")
    |> hash_password()
  end

  defp hash_password(changeset) do
    case get_change(changeset, :password) do
      nil -> changeset
      password -> put_change(changeset, :password_hash, Argon2.hash_pwd_salt(password))
    end
  end
end
