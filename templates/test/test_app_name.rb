require 'test/unit'

class #{app_name.camelize}Test < Test::Unit::TestCase
  def setup
    @basic = #{app_name.camelize}::Basic.new
  end

  def test_magic
    assert @basic, "No basic"
  end
end
