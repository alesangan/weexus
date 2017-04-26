require 'test_helper'

class ExclusionsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @exclusion = exclusions(:one)
  end

  test "should get index" do
    get exclusions_url
    assert_response :success
  end

  test "should get new" do
    get new_exclusion_url
    assert_response :success
  end

  test "should create exclusion" do
    assert_difference('Exclusion.count') do
      post exclusions_url, params: { exclusion: { weighting: @exclusion.weighting, word: @exclusion.word } }
    end

    assert_redirected_to exclusion_url(Exclusion.last)
  end

  test "should show exclusion" do
    get exclusion_url(@exclusion)
    assert_response :success
  end

  test "should get edit" do
    get edit_exclusion_url(@exclusion)
    assert_response :success
  end

  test "should update exclusion" do
    patch exclusion_url(@exclusion), params: { exclusion: { weighting: @exclusion.weighting, word: @exclusion.word } }
    assert_redirected_to exclusion_url(@exclusion)
  end

  test "should destroy exclusion" do
    assert_difference('Exclusion.count', -1) do
      delete exclusion_url(@exclusion)
    end

    assert_redirected_to exclusions_url
  end
end
