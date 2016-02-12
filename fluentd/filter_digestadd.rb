# Simple filter that adds fields with md5 hash of specified field values.
# Also it may extended with another converting methods.
# Example fluentd config:
#  <source>
#    type dummy
#    tag sometag
#    dummy {"host": "abc", "another": "somevalue", "qq": "qwerty"}
#  </source>
#
#  <filter sometag>
#    type digestadd
#    # host_md5 - result field with md5 hexdigest of 'host' field value
#    # format of the map: dest_field_name: source_field_name
#    # if there are no source field in the record then nothing will be added
#    # for that field.
#    md5 {"host_md5": "host", "qqqq_md5": "qq", "asdr": "dfg"}
#  </filter>
#
#  <match **>
#    type stdout
#  </match>
# 
# $ bundle exec fluentd -c test.conf -p ./
# 2016-02-12 13:01:30 +0300 cleanup: {"host":"abc","another":"somevalue","qq":"qwerty","host_md5":"900150983cd24fb0d6963f7d28e17f72","qqqq_md5":"d8578edf8458ce06fbc5bb76a58c5ca4"}
# 2016-02-12 13:01:31 +0300 cleanup: {"host":"abc","another":"somevalue","qq":"qwerty","host_md5":"900150983cd24fb0d6963f7d28e17f72","qqqq_md5":"d8578edf8458ce06fbc5bb76a58c5ca4"}

require 'digest/md5'

class Fluent::DigestAddFilter < Fluent::Filter

  Fluent::Plugin.register_filter('digestadd', self)

  config_param :md5, :hash, :default => {}

  def initialize
    super
  end

  def configure(conf)
    super
  end

  def filter(tag, time, record)
    @md5.each do |newkey, oldkey|
      if record.has_key?(oldkey)
        record[newkey] = Digest::MD5.hexdigest(record[oldkey])
      end
    end
    record
  end
end if defined?(Fluent::Filter)
