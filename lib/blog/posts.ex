defmodule Blog.Posts do
  alias Blog.Posts.Post
  alias Blog.Repo
  alias Blog.Users

  def get_by_id(%{id: id}) do
    post = Repo.get(%Post{}, id)

    case post do
      nil -> {:error, "Post not found"}
      post -> {:ok, post}
    end
  end

  def create(%{author: username}, attrs) do
    user = Users.get(%{username: username})

    case user do
      {:error, reason} ->
        {:error, reason}

      {:ok, user} ->
        post = Ecto.build_assoc(user, :posts, attrs)

        {:ok, post}
    end
  end

  def delete(args) do
    case get_by_id(args) do
      {:error, reason} -> {:error, reason}
      {:ok, post} -> Repo.delete(post)
    end
  end

  def update(id, attrs) do
    case get_by_id(id) do
      {:error, reason} -> {:error, reason}
      {:ok, post} -> Repo.update(post, attrs)
    end
  end
end
