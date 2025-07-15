defmodule MyAppWeb.UserLive.IcValidator do
  use MyAppWeb, :live_component

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <.header>
        {@title}
        <:subtitle>Validate user IC number</:subtitle>
      </.header>

      <.simple_form
        for={@form}
        id="ic-validator-form"
        phx-target={@myself}
        phx-change="validate"
        phx-submit="close"
      >
        <.input field={@form[:ic]} type="text" label="IC Number" placeholder="e.g., 123456789012"/>

        <div :if={@result} class="mt-6 p-4 bg-gray-50 rounded-lg">
          <h3 class="text-lg font-semibold text-gray-900 mb-2">IC Analysis Result</h3>
          <div class="space-y-2">
            <div class="flex justify-between">
              <span class="font-medium text-gray-700">Origin:</span>
              <span class="font-semibold" style={"color: #{@origin_color}"}>
                {@origin}
              </span>
            </div>
            <div class="flex justify-between">
              <span class="font-medium text-gray-700">Gender:</span>
              <span class="font-semibold" style={"color: #{@gender_color}"}>
                {@gender}
              </span>
            </div>
            <div class="flex justify-between">
              <span class="font-medium text-gray-700">IC Format:</span>
              <span class="text-sm text-gray-600">{@ic_format}</span>
            </div>
          </div>
        </div>

        <:actions>
          <.button type="submit">Close</.button>
        </:actions>
      </.simple_form>
    </div>
    """
  end

  @impl true
  def update(assigns, socket) do
    {:ok,
     socket
     |> assign(assigns)
     |> assign(:result, nil)
     |> assign(:origin, nil)
     |> assign(:gender, nil)
     |> assign(:origin_color, "#000000")
     |> assign(:gender_color, "#000000")
     |> assign(:ic_format, nil)
     |> assign_new(:form, fn ->
       to_form(%{"ic" => ""}, as: :ic)
     end)}
  end

  @impl true
  def handle_event("validate", %{"ic" => ic_params}, socket) do
    ic_number = String.trim(ic_params["ic"])

    {result, origin, gender, origin_color, gender_color, ic_format} = validate_ic(ic_number)

    {:noreply,
     socket
     |> assign(:result, result)
     |> assign(:origin, origin)
     |> assign(:gender, gender)
     |> assign(:origin_color, origin_color)
     |> assign(:gender_color, gender_color)
     |> assign(:ic_format, ic_format)
     |> assign(:form, to_form(ic_params, as: :ic))}
  end

  def handle_event("close", _params, socket) do
    {:noreply, push_patch(socket, to: socket.assigns.patch)}
  end

  defp validate_ic(ic_number) when is_binary(ic_number) and byte_size(ic_number) == 12 do
    # Split the IC number into parts: xxxxxx-yy-zzzz
    case String.split_at(ic_number, 6) do
      {first_part, remaining} ->
        case String.split_at(remaining, 2) do
          {middle_part, last_part} ->
            parse_ic_parts(first_part, middle_part, last_part)
          _ ->
            {false, "Invalid format", "Invalid format", "#EF4444", "#EF4444", "Invalid"}
        end
      _ ->
        {false, "Invalid format", "Invalid format", "#EF4444", "#EF4444", "Invalid"}
    end
  end

  defp validate_ic(_), do: {false, "Invalid IC number", "Invalid IC number", "#EF4444", "#EF4444", "Invalid"}

  defp parse_ic_parts(first_part, middle_part, last_part) do
    # Validate that all parts are numeric
    if is_numeric(first_part) and is_numeric(middle_part) and is_numeric(last_part) do
      middle_num = String.to_integer(middle_part)
      last_num = String.to_integer(last_part)

      # Determine origin based on middle part (yy)
      {origin, origin_color} =
        case middle_num do
          1 -> {"Johor", "#10B981"}
          2 -> {"Kedah", "#10B981"}
          3 -> {"Kelantan", "#10B981"}
          4 -> {"Sabahan", "#10B981"}
          5 -> {"Negeri Sembilan", "#10B981"}
          6 -> {"Pahang", "#10B981"}
          7 -> {"Pulau Pinang", "#10B981"}
          8 -> {"Perak", "#10B981"}
          9 -> {"Perlis", "#10B981"}
          10 -> {"Selangor", "#10B981"}
          11 -> {"Terengganu", "#10B981"}
          12 -> {"Sabahan", "#10B981"}
          13 -> {"Sarawak", "#10B981"}
          14 -> {"Kuala Lumpur", "#10B981"}
          15 -> {"Labuan", "#10B981"}
          16 -> {"Putrajaya", "#10B981"}
          _ -> {"Undefined", "#3B82F6"}
        end

      # Determine gender based on last part (zzzz)
      {gender, gender_color} =
        case rem(last_num, 2) do
          1 -> {"Male", "#3B82F6"}
          0 -> {"Female", "#EC4899"}
        end

      ic_format = "#{first_part}-#{middle_part}-#{last_part}"

      {true, origin, gender, origin_color, gender_color, ic_format}
    else
      {false, "Invalid format", "Invalid format", "#EF4444", "#EF4444", "Invalid"}
    end
  end

  defp is_numeric(string) do
    String.match?(string, ~r/^\d+$/)
  end
end
