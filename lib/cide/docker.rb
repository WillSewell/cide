require 'shellwords'

module CIDE
  # Simple docker client helper
  module Docker
    # Generates a valid id for docker from any string
    def self.id(str)
      "#{str}".downcase.gsub(/[^a-z0-9\-_.]/, '_')
    end

    # Raised when a docker command exits with a status higher than zero
    class Error < StandardError
      attr_reader :exitstatus
      def initialize(exitstatus)
        @exitstatus = exitstatus
        super("Failed with exitstatus #{exitstatus}")
      end
    end

    class VersionError < StandardError; end

    def docker(*args, **opts)
      setup_docker

      ret = run Shellwords.join(['docker'] + args), opts
      exitstatus = $?.exitstatus
      fail Error, exitstatus if exitstatus > 0
      ret
    end

    protected

    def setup_docker
      @setup_docker ||= (
        if `uname`.strip == 'Darwin' && !ENV['DOCKER_HOST']
          unless system('which boot2docker >/dev/null 2>&1')
            puts 'make sure boot2docker is installed and running'
            puts
            puts '> brew install boot2docker'
            exit 1
          end

          `boot2docker shellinit 2>/dev/null`
            .lines
            .grep(/export (\w+)=(.*)/) { ENV[$1] = $2.strip }
        end

        # Check docker version
        docker_version = nil
        case `docker version 2>/dev/null`
        when /Client version: ([^\s]+)/
          docker_version = $1
        when /\s+Version:\s+([^\s]+)/
          docker_version = $1
        else
          fail VersionError, 'Unknown docker version'
        end

        if Gem::Version.new(docker_version) < Gem::Version.new('1.5.0')
          fail VersionError, "Docker version #{$1} too old"
        end

        true
      )
    end
  end
end
