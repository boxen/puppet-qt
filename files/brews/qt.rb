require 'formula'

class Qt < Formula
  homepage 'http://qt-project.org/'
  if MacOS.version < :mavericks
    url 'http://download.qt-project.org/official_releases/qt/4.8/4.8.5/qt-everywhere-opensource-src-4.8.5.tar.gz'
    sha1 '745f9ebf091696c0d5403ce691dc28c039d77b9e'
  else
    # This is a snapshot of the current qt-4.8 branch. It's been used by a
    # bunch of people to get Qt working on Mavericks and 4.8.5 needs too many
    # patches to compile any time soon (January-ish):
    # http://permalink.gmane.org/gmane.comp.lib.qt.devel/13812
    url 'https://github.com/qtproject/qt/archive/f44310c25b372f494586dbb5b305f7e81ca63000.tar.gz'
    sha1 '51548326463068912fb4d9de04b0f6b2e267d064'
  end

  version "4.8.5-boxen2"


  option :universal
  option 'with-qt3support', 'Build with deprecated Qt3Support module support'
  option 'with-docs', 'Build documentation'
  option 'developer', 'Build and link with developer options'

  depends_on "d-bus" => :optional
  depends_on "mysql" => :optional

  odie 'qt: --with-qtdbus has been renamed to --with-d-bus' if build.include? 'with-qtdbus'
  odie 'qt: --with-demos-examples is no longer supported' if build.include? 'with-demos-examples'
  odie 'qt: --with-debug-and-release is no longer supported' if build.include? 'with-debug-and-release'

  def install
    ENV.universal_binary if build.universal?

    args = ["-prefix", prefix,
            "-system-zlib",
            "-confirm-license", "-opensource",
            "-nomake", "demos", "-nomake", "examples",
            "-cocoa", "-fast", "-release"]

    # we have to disable these to avoid triggering optimization code
    # that will fail in superenv (in --env=std, Qt seems aware of this)
    args << '-no-3dnow' << '-no-ssse3' if superenv?

    args << "-L#{MacOS::X11.lib}" << "-I#{MacOS::X11.include}" if MacOS::X11.installed?

    if ENV.compiler == :clang
        args << "-platform"

        if MacOS.version >= :mavericks
          args << "unsupported/macx-clang-libc++"
        else
          args << "unsupported/macx-clang"
        end
    end

    args << "-plugin-sql-mysql" if build.with? 'mysql'

    if build.with? 'd-bus'
      dbus_opt = Formula.factory('d-bus').opt_prefix
      args << "-I#{dbus_opt}/lib/dbus-1.0/include"
      args << "-I#{dbus_opt}/include/dbus-1.0"
      args << "-L#{dbus_opt}/lib"
      args << "-ldbus-1"
    end

    if build.with? 'qt3support'
      args << "-qt3support"
    else
      args << "-no-qt3support"
    end

    unless build.with? 'docs'
      args << "-nomake" << "docs"
    end

    if MacOS.prefer_64_bit? or build.universal?
      args << '-arch' << 'x86_64'
    end

    if !MacOS.prefer_64_bit? or build.universal?
      args << '-arch' << 'x86'
    end

    args << '-developer-build' if build.include? 'developer'

    system "./configure", *args
    system "make"
    ENV.j1
    system "make install"

    # what are these anyway?
    (bin+'pixeltool.app').rmtree
    (bin+'qhelpconverter.app').rmtree
    # remove porting file for non-humans
    (prefix+'q3porting.xml').unlink if build.without? 'qt3support'

    # Some config scripts will only find Qt in a "Frameworks" folder
    frameworks.mkpath
    ln_s Dir["#{lib}/*.framework"], frameworks

    # The pkg-config files installed suggest that headers can be found in the
    # `include` directory. Make this so by creating symlinks from `include` to
    # the Frameworks' Headers folders.
    Pathname.glob(lib + '*.framework/Headers').each do |path|
      framework_name = File.basename(File.dirname(path), '.framework')
      ln_s path.realpath, include+framework_name
    end

    Pathname.glob(bin + '*.app').each do |path|
      mv path, prefix
    end
  end

  test do
    system "#{bin}/qmake", '-project'
  end

  def caveats; <<-EOS.undent
    We agreed to the Qt opensource license for you.
    If this is unacceptable you should uninstall.
    EOS
  end
end
