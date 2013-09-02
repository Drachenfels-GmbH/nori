require 'spec_helper'

describe Nori::TypeConverter do
  describe "#detect_namespace_prefixes!" do
    let(:namespaces) { {} }
    let(:type_converter) { Nori::TypeConverter.new.tap {|c| c.detect_namespace_prefixes!(xml, namespaces)} }

    describe 'namespace prefixes' do
      context 'when document is empty' do
        let(:xml) { '' }
        subject { type_converter }
        its(:attribute_prefix) { should be_nil }
        its(:type_prefix) { should be_nil }
      end

      context 'when document has no XML header' do
        let(:xml) { '<foo>1</foo>' }
        subject { type_converter }
        its(:attribute_prefix) { should be_nil }
        its(:type_prefix) { should be_nil }
      end

      context 'when no namespaces are declared' do
        let(:xml) {
          <<-EOT
            <?xml version="1.0" encoding="UTF-8"?>
            <Envelope>
              <Body>
              </Body>
            </Envelope>
          EOT
        }
        subject { type_converter }
        its(:attribute_prefix) { should be_nil }
        its(:type_prefix) { should be_nil }
      end

      context 'when XMLSchema namespace is declared' do
        let(:xml) {
          <<-EOT
            <?xml version="1.0" encoding="UTF-8"?>
            <Envelope xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" >
              <Body>
              </Body>
            </Envelope>
          EOT
        }
        subject { type_converter }
        its(:attribute_prefix) { should eq('xsi') }
        its(:type_prefix) { should eq('xsd') }
      end

      context 'when custom namespace is declared' do
        let(:namespaces) {
          { :attribute_namespace => 'http://company.com/foo', :type_namespace => 'http://company.com/bar' }
        }
        let(:xml) {
          <<-EOT
            <?xml version="1.0" encoding="UTF-8"?>
            <Envelope xmlns:foo="http://company.com/foo" xmlns:bar="http://company.com/bar" >
              <Body>
              </Body>
            </Envelope>
          EOT
        }
        subject { type_converter }
        its(:attribute_prefix) { should eq('foo') }
        its(:type_prefix) { should eq('bar') }
      end
    end
  end
end
