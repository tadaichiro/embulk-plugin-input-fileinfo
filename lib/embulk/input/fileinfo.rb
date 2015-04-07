
module Embulk
  module Input
    class InputFileInformation < InputPlugin
      require 'find'

      Plugin.register_input('fileinfo', self)

      def self.transaction(config, &control)
        
        threads = 1
        rootdir = config.param('rootdir', :string)
        ext = config.param('extension', :string, default: '*')
        sizelowerlimit = config.param('sizelowerlimit', :long, default: 0)

        task = {'rootdir' => rootdir, 'ext' => ext, 'sizelowerlimit' => sizelowerlimit}

        columns = [
          Column.new(0, 'FILE_NAME', :string),
          Column.new(1, 'FILE_PATH', :string),
          Column.new(2, 'FILE_SIZE_RAW', :long)
        ]

        puts "File information generation started."
        commit_reports = yield(task, columns, threads)
        puts "File information input finished."

        return {}

      end

      def initialize(task, schema, index, page_builder)
        super
      end

      def run

        rootdir = @task['rootdir']
        ext = @task['ext']
        sizelowerlimit = @task['sizelowerlimit']

        Dir.glob(rootdir + '/**/*') {|f|

          next unless FileTest.file?(f)
          
          s = File::stat(f)

          next if ext != "*" && File::extname(f) == ext 
          next if s.size < sizelowerlimit * 1024 * 1024

          @page_builder.add([File::basename(f), File::dirname(f), s.size])

        }

        @page_builder.finish

            commit_report = {
            }
        return commit_report
      end
    end
  end
end