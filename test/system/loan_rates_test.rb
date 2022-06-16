require "application_system_test_case"

class LoanRatesTest < ApplicationSystemTestCase
  setup do
    @loan_rate = loan_rates(:one)
  end

  test "visiting the index" do
    visit loan_rates_url
    assert_selector "h1", text: "Loan Rates"
  end

  test "creating a Loan rate" do
    visit loan_rates_url
    click_on "New Loan Rate"

    fill_in "Address", with: @loan_rate.address
    fill_in "Rate", with: @loan_rate.rate
    click_on "Create Loan rate"

    assert_text "Loan rate was successfully created"
    click_on "Back"
  end

  test "updating a Loan rate" do
    visit loan_rates_url
    click_on "Edit", match: :first

    fill_in "Address", with: @loan_rate.address
    fill_in "Rate", with: @loan_rate.rate
    click_on "Update Loan rate"

    assert_text "Loan rate was successfully updated"
    click_on "Back"
  end

  test "destroying a Loan rate" do
    visit loan_rates_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Loan rate was successfully destroyed"
  end
end
