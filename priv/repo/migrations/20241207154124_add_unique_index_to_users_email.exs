defmodule AuthService.Repo.Migrations.AddUniqueIndexToUsersEmail do
  use Ecto.Migration

  def change do
    execute("""
    DO $$
    BEGIN
      IF NOT EXISTS (
        SELECT 1
        FROM pg_indexes
        WHERE schemaname = 'public' AND indexname = 'users_email_index'
      ) THEN
        CREATE UNIQUE INDEX users_email_index ON users (email);
      END IF;
    END $$;
    """)
  end
end
