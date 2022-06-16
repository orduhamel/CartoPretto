require "test_helper"

class LoanRatesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @loan_rate = loan_rates(:one)
  end

  test "should get index" do
    get loan_rates_url
    assert_response :success
  end

  test "should get new" do
    get new_loan_rate_url
    assert_response :success
  end

  test "should create loan_rate" do
    assert_difference('LoanRate.count') do
      post loan_rates_url, params: { loan_rate: { address: @loan_rate.address, rate: @loan_rate.rate } }
    end

    assert_redirected_to loan_rate_url(LoanRate.last)
  end

  test "should show loan_rate" do
    get loan_rate_url(@loan_rate)
    assert_response :success
  end

  test "should get edit" do
    get edit_loan_rate_url(@loan_rate)
    assert_response :success
  end

  test "should update loan_rate" do
    patch loan_rate_url(@loan_rate), params: { loan_rate: { address: @loan_rate.address, rate: @loan_rate.rate } }
    assert_redirected_to loan_rate_url(@loan_rate)
  end

  test "should destroy loan_rate" do
    assert_difference('LoanRate.count', -1) do
      delete loan_rate_url(@loan_rate)
    end

    assert_redirected_to loan_rates_url
  end
end
