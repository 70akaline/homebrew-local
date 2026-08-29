class Ctf < Formula
  desc "Distributed-memory tensor library for C++ and Python"
  homepage "https://github.com/cyclops-community/ctf"
  url "https://github.com/cyclops-community/ctf.git",
      revision: "7866d44f3a2c304401502925e2ef84c1edb4d11e"
  version "1.5.5-dev-20260727"
  license "BSD-3-Clause"

  depends_on "cython" => :build
  depends_on "python-setuptools" => :build
  depends_on "numpy"
  depends_on "open-mpi"
  depends_on "openblas"
  depends_on "python@3.14"
  depends_on "scalapack"

  def python3
    "python3.14"
  end

  def install
    # Upstream always names the shared library libctf.so, including on macOS.
    # Use the native suffix and a stable install name for linked consumers.
    inreplace "Makefile", "libctf.so", "libctf.dylib"
    inreplace "Makefile",
              "$(FCXX) -shared -o $(BDIR)/lib_shared/libctf.dylib",
              "$(FCXX) -shared -Wl,-install_name,#{lib}/libctf.dylib -o $(BDIR)/lib_shared/libctf.dylib"

    mpi = Formula["open-mpi"]
    openblas = Formula["openblas"]
    scalapack = Formula["scalapack"]
    library_path = "-L#{scalapack.opt_lib} -L#{openblas.opt_lib}"
    libraries = "-lscalapack -lopenblas"

    system "./configure",
           "--build-dir=#{buildpath}/build",
           "--install-dir=#{prefix}",
           "--with-lapack",
           "--with-scalapack",
           "CXX=#{mpi.opt_bin}/mpicxx",
           "CXXFLAGS=-O3 -DNOMALLINFO",
           "LIB_PATH=#{library_path}",
           "LD_LIB_PATH=#{library_path}",
           "LIBS=#{libraries}",
           "LD_LIBS=#{libraries}"

    system "make", "-C", "build", "-j#{ENV.make_jobs}", "install"

    ln_s buildpath/"build/setup.py", buildpath/"src_python/setup.py"
    ENV.prepend_path "PYTHONPATH", formula_opt_libexec("cython")/Language::Python.site_packages(python3)
    system python3, "-m", "pip", "install", *std_pip_args, "./src_python"
  end

  test do
    (testpath/"test.cpp").write <<~CPP
      #include <ctf.hpp>

      int main(int argc, char **argv) {
        MPI_Init(&argc, &argv);
        {
          CTF::World world(argc, argv);
          int lengths[] = {2};
          CTF::Tensor<double> tensor(1, lengths, world);
          tensor["i"] = 1.0;
          if (tensor.norm2() <= 0.0) return 1;
        }
        MPI_Finalize();
        return 0;
      }
    CPP

    system formula_opt_bin("open-mpi")/"mpicxx", "test.cpp", "-I#{include}",
           "-L#{lib}", "-lctf", "-L#{formula_opt_lib("scalapack")}", "-lscalapack",
           "-L#{formula_opt_lib("openblas")}", "-lopenblas", "-o", "test"
    mpirun = formula_opt_bin("open-mpi")/"mpirun"
    system mpirun, "--map-by", ":OVERSUBSCRIBE", "-np", "2", "./test"
    system mpirun, "--map-by", ":OVERSUBSCRIBE", "-np", "2", python3, "-c",
           "import ctf; a = ctf.tensor([2]); assert a.shape == (2,); del a; ctf.MPI_Stop()"
  end
end
