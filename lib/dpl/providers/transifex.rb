module Dpl
  module Providers
    class Transifex < Provider
      description sq(<<-str)
        tbd
      str

      experimental

      opt '--username NAME',   'Transifex username', required: true
      opt '--password PASS',   'Transifex password', required: true
      opt '--hostname NAME',   'Transifex hostname', default: 'www.transifex.com'
      # this used to be 0.11, but that version does not seem to exist in pip.
      # should check this with transifex though
      opt '--cli_version VER', 'CLI version to install', default: '0.9.1'

      cmds status: 'tx status',
           push:   'tx push --source --no-interactive'

      def install
        pip_install 'transifex', 'transifex', cli_version
      end

      def setup
        write_rc
      end

      def login
        shell :status
      end

      def deploy
        shell :push, retry: true
      end

      private

        RC = sq(<<-rc)
          [%{url}]
          hostname = %{url}
          username = %{username}
          password = %{password}
        rc

        def write_rc
          write_file('~/.transifexrc', interpolate(RC))
        end

        def url
          hostname.start_with?('https://') ? hostname : "https://#{hostname}"
        end
    end
  end
end
