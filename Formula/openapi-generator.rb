class OpenapiGenerator < Formula
  desc "Generate clients, server & docs from an OpenAPI spec (v2, v3)"
  homepage "https://openapi-generator.tech/"
  url "https://search.maven.org/remotecontent?filepath=org/openapitools/openapi-generator-cli/6.5.0/openapi-generator-cli-6.5.0.jar"
  sha256 "f18d771e98f2c5bb169d1d1961de4f94866d2901abc1e16177dd7e9299834721"
  license "Apache-2.0"

  livecheck do
    url "https://search.maven.org/remotecontent?filepath=org/openapitools/openapi-generator-cli/maven-metadata.xml"
    regex(%r{<version>v?(\d+(?:\.\d+)+)</version>}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "cf5a1b9838752ba22cea753f4e37f1cb655686d5ce60ffc914feeef47c21e316"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "cf5a1b9838752ba22cea753f4e37f1cb655686d5ce60ffc914feeef47c21e316"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "cf5a1b9838752ba22cea753f4e37f1cb655686d5ce60ffc914feeef47c21e316"
    sha256 cellar: :any_skip_relocation, ventura:        "cf5a1b9838752ba22cea753f4e37f1cb655686d5ce60ffc914feeef47c21e316"
    sha256 cellar: :any_skip_relocation, monterey:       "cf5a1b9838752ba22cea753f4e37f1cb655686d5ce60ffc914feeef47c21e316"
    sha256 cellar: :any_skip_relocation, big_sur:        "cf5a1b9838752ba22cea753f4e37f1cb655686d5ce60ffc914feeef47c21e316"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0394b01e2e74d74251ab76e0994b2deead4b01a2988442a66c94b340b5187329"
  end

  head do
    url "https://github.com/OpenAPITools/openapi-generator.git", branch: "master"

    depends_on "maven" => :build
  end

  depends_on "openjdk@11"

  def install
    if build.head?
      system "mvn", "clean", "package", "-Dmaven.javadoc.skip=true"
      libexec.install "modules/openapi-generator-cli/target/openapi-generator-cli.jar"
    else
      libexec.install "openapi-generator-cli-#{version}.jar" => "openapi-generator-cli.jar"
    end

    bin.write_jar_script libexec/"openapi-generator-cli.jar", "openapi-generator", java_version: "11"
  end

  test do
    # From the OpenAPI Spec website
    # https://web.archive.org/web/20230505222426/https://swagger.io/docs/specification/basic-structure/
    (testpath/"minimal.yaml").write <<~EOS
      ---
      openapi: 3.0.3
      info:
        version: 0.0.0
        title: Sample API
      servers:
        - url: http://api.example.com/v1
          description: Optional server description, e.g. Main (production) server
        - url: http://staging-api.example.com
          description: Optional server description, e.g. Internal staging server for testing
      paths:
        /users:
          get:
            summary: Returns a list of users.
            responses:
              '200':
                description: A JSON array of user names
                content:
                  application/json:
                    schema:
                      type: array
                      items:
                        type: string
    EOS
    system bin/"openapi-generator", "generate", "-i", "minimal.yaml", "-g", "openapi", "-o", "./"
    # Python is broken for (at least) Java 20
    system bin/"openapi-generator", "generate", "-i", "minimal.yaml", "-g", "python", "-o", "./"
  end
end
