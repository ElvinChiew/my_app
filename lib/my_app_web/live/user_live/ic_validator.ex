defmodule MyAppWeb.UserLive.IcValidator do
  use MyAppWeb, :live_view

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <.header>
        {@title}
        <:subtitle>Calculate BMI (Body Mass Index) for {@user.name}</:subtitle>
      </.header>

      <.simple_form
        for={@form}
        id="bmi-calculator-form"
        phx-target={@myself}
        phx-change="calculate"
        phx-submit="close"
      >
        <.input field={@form[:height]} type="number" label="Height (cm)" step="0.1" min="1" />
        <.input field={@form[:weight]} type="number" label="Weight (kg)" step="0.1" min="1" />

        <div :if={@bmi} class="mt-6 p-4 bg-gray-50 rounded-lg">
          <h3 class="text-lg font-semibold text-gray-900 mb-2">BMI Result</h3>
          <div class="text-2xl font-bold mb-2" style={"color: #{@bmi_color}"}>
            {@bmi}
          </div>
          <div class="text-sm font-medium" style={"color: #{@bmi_color}"}>
            {@bmi_category}
          </div>
          <div class="mt-3 text-sm text-gray-600">
            <p><strong>BMI Categories:</strong></p>
            <ul class="mt-1 space-y-1">
              <li>Underweight: Less than 18.5</li>
              <li>Normal weight: 18.5 - 24.9</li>
              <li>Overweight: 25.0 - 29.9</li>
              <li>Obese: 30.0 and above</li>
            </ul>
          </div>
        </div>

        <:actions>
          <.button type="submit">Close</.button>
        </:actions>
      </.simple_form>
    </div>
    """
  end
end
