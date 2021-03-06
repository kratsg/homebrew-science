class Adam < Formula
  desc "Genomics analysis platform with specialized file formats built using Apache Avro, Apache Spark and Parquet"
  homepage "https://github.com/bigdatagenomics/adam"
  url "https://repo1.maven.org/maven2/org/bdgenomics/adam/adam-distribution_2.10/0.17.1/adam-distribution_2.10-0.17.1-bin.tar.gz"
  sha256 "30ec40d43e8f2e0ac0690056e2437f2a4af4fad9033f1e41021898b65fa2d986"

  bottle do
    cellar :any_skip_relocation
    sha256 "fd710b911bf60d3ec091531dc7c2b44d0ea4d9e814d24382ed74e82c84ffa3d2" => :yosemite
    sha256 "d044b5c388ec3a7d583657bf84d8b9da1b42b7a7aaaf9ff437f48d0ccdf960f7" => :mavericks
    sha256 "8d2d9899d83308a4187b3a2f015f07b73ddf67266c4424ad9b0312a034910833" => :mountain_lion
  end

  depends_on "apache-spark"

  head do
    url "https://github.com/bigdatagenomics/adam.git", :shallow => false
    depends_on "maven" => :build
  end

  option "without-check", "Disable build-time checking (not recommended)"

  def install
    if build.head?
      system "mvn", "clean", "install",
                    "-DskipAssembly=True",
                    "-DskipTests=" + (build.with?("check") ? "False" : "True")
      libexec.install Dir["adam-cli/target/appassembler/*"]
    else
      libexec.install Dir["*"]
    end
    rm "#{libexec}/bin/adam.bat"
    bin.write_exec_script Dir["#{libexec}/bin/*"]
  end

  test do
    system "#{bin}/adam-submit", "buildinfo"
  end
end
