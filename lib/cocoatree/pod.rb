module Cocoatree
  class Pod
    attr_reader :spec

    def initialize spec
      @spec = spec
    end

    def method_missing method_name, *args
      if spec.respond_to? method_name
        spec.send(method_name, *args)
      end
    end

    def url
      spec.source[:git]
    end

    def github?
      !github_data.empty?
    end

    def github
      github_data.join '/'
    end

    def stars
      @stars ||= (fetch_stars || -1)
    end

  private

    def fetch_stars
      Cocoatree.github_cache.fetch(github, 'stars_count') do
        Octokit.repository(github)['watchers_count']
      end
    rescue Octokit::NotFound => e
      nil
    end

    def github_data
      matchdata = /github.com\/(.+)\/(.+).git/.match url
      return [] unless matchdata
      matchdata.captures
    end
  end
end