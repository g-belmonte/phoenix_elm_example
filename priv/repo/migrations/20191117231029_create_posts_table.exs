defmodule Blog.Repo.Migrations.CreatePostsTable do
  use Ecto.Migration

  def change do
    create table("posts") do
      add :title, :string
      add :contents, :text

      timestamps(type: :utc_datetime_usec)
    end

    create unique_index(:posts, [:title])
  end
end
