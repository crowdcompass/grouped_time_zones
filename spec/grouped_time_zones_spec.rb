require 'active_support/time_with_zone'
require 'spec_helper'
require 'nokogiri'

describe GroupedTimeZones::ViewHelpers do
  include GroupedTimeZones::ViewHelpers

  let!(:us_zones) { ActiveSupport::TimeZone.us_zones }
  let!(:all_zones) { ActiveSupport::TimeZone.all }
  let(:non_us_zones) { all_zones - us_zones }
  let(:non_us_uniq_zones) do
    (all_zones.uniq { |tz| tz.tzinfo.identifier }) - us_zones
  end
  let(:all_uniq_zones) { non_us_uniq_zones + us_zones }

  it "should return an array of time zones grouped by USA first and then other" do
    result = grouped_time_zones
    result[0][0].should == 'United States'
    result[0][1].should have(us_zones.count).items
    result[0][1][0][0].should =~ /\(GMT-\d{2}:\d{2}\)/
    result[1][0].should == 'Other'
    result[1][1].should have(non_us_zones.count).items
  end

  it "time_zone_select should return a select html tag" do
    user = double("user", time_zone: 'Pacific/Honolulu')

    result = Nokogiri::HTML.parse grouped_time_zone_select('user', :time_zone, user)
    # The next test is comment because from version 5.03 of ActiveSupport::Timezone some time
    # zones were include in other, deleting these from the list. The idea was had a generic
    # list instead an specific list. To more information you can visit the next thread.
    # https://github.com/rails/rails/issues/12461
    # result.css('select option').should have(all_zones.count).items
    selected = result.css('select option[selected="selected"]')
    selected.should have(1).item
    selected.first.attributes['value'].value.should eq 'Pacific/Honolulu'

    opt_groups = result.css('select optgroup')
    opt_groups.should have(2).items
    opt_groups.first.attributes['label'].value.should eq 'United States'
    opt_groups.last.attributes['label'].value.should eq 'Other'
  end

  context "Unique Zones Only" do
    it "should return an array of unique named time zones grouped by USA and then Other" do
      result = grouped_time_zones(true)
      result[0][0].should == 'United States'
      result[0][1].should have(us_zones.count).items
      result[0][1][0][0].should =~ /\(GMT-\d{2}:\d{2}\)/
      result[1][0].should == 'Other'
      result[1][1].should have(non_us_uniq_zones.count).items
    end

    it "time_zone_select should return a select html tag with unique option values" do
      user = double("user", time_zone: 'Pacific/Honolulu')

      result = Nokogiri::HTML.parse grouped_time_zone_select('user', :time_zone, user, true)
      result.css('select option').should have(all_uniq_zones.count).items
      selected = result.css('select option[selected="selected"]')
      selected.should have(1).item
      selected.first.attributes['value'].value.should eq 'Pacific/Honolulu'

      opt_groups = result.css('select optgroup')
      opt_groups.should have(2).items
      opt_groups.first.attributes['label'].value.should eq 'United States'
      opt_groups.last.attributes['label'].value.should eq 'Other'
    end
  end

  describe 'zone_from_group_or_any_for_identifier' do
    
    it "returns the TZ from the grouped TZs" do
      zone_from_group_or_any_for_identifier("Pacific/Honolulu").should =~ / Hawaii/
    end

    it "falls back on all TZs" do
      zone_from_group_or_any_for_identifier("Hawaii").should =~ / Hawaii/
    end
  end
end
