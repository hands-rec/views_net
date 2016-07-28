require 'spec_helper'

describe ViewsNet do
  it 'has a version number' do
    expect(ViewsNet::VERSION).not_to be nil
  end

  describe "ViewsNet::Client" do
    it "#payment_amount" do
      client = ViewsNet::Client.new('./test/test.yaml')
      expect(client.payment_amount[:month]).to match 'お客さまのお支払総額'
      expect(client.payment_amount[:amount]).to match '円'
    end
  end


end
