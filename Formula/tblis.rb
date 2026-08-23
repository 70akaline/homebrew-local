class Tblis < Formula
  desc "Tensor-Based Library Instantiation Software"
  homepage "https://github.com/MatthewsResearchGroup/tblis"
  url "https://github.com/MatthewsResearchGroup/tblis.git",
      revision: "eb719e718976572e0ab53975f4e0c799faeb35f2"
  version "2.0.0-dev-20251121"
  license "BSD-3-Clause"

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "blis"

  def install
    # TBLIS only consumes the static plugin archive. The upstream BLIS plugin
    # helper otherwise also links a dylib with the C driver, which omits libc++.
    inreplace "CMakeLists.txt", "        -f --build", "        --disable-shared\n        -f --build"

    # Preserve the external BLIS dependency in installed pkg-config and CMake
    # metadata. Upstream currently emits bundled-BLIS flags for this path.
    inreplace "CMakeLists.txt",
              'set(PKGCONFIG_LIBS "-L${libdir}/tblis -lblis_tblis -lblis_core")',
              'set(PKGCONFIG_LIBS "-L\${libdir}/tblis -lblis_tblis")'
    inreplace "CMakeLists.txt", 'set(PKGCONFIG_REQUIRES "tci >= 1.0")',
              'set(PKGCONFIG_REQUIRES "tci >= 1.0, blis >= 2.0")'
    inreplace "TBLISConfig.cmake.in", "@BLIS_DEPENDENCY@", <<~CMAKE.chomp
      find_dependency(PkgConfig)
      pkg_check_modules(BLIS REQUIRED IMPORTED_TARGET blis>=2.0)
    CMAKE

    args = std_cmake_args + %w[
      -DENABLE_COMPAT=ON
      -DENABLE_HWLOC=OFF
      -DENABLE_MEMKIND=OFF
      -DENABLE_TESTS=OFF
      -DENABLE_THREAD_MODEL=pthreads
    ]

    system "cmake", "-S", ".", "-B", "build", *args
    system "cmake", "--build", "build", "--parallel"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.cpp").write <<~CPP
      #include <cmath>
      #include <tblis.h>

      int main() {
        double a[] = {1.0, 2.0, 3.0, 4.0};
        double b[] = {5.0, 6.0, 7.0, 8.0};
        double c[] = {0.0, 0.0, 0.0, 0.0};
        tblis::len_type lengths[] = {2, 2};
        tblis::stride_type strides[] = {2, 1};
        tblis::label_type a_labels[] = {'i', 'k'};
        tblis::label_type b_labels[] = {'k', 'j'};
        tblis::label_type c_labels[] = {'i', 'j'};
        tblis::tblis_tensor ta, tb, tc;

        tblis::tblis_init_tensor_d(&ta, 2, lengths, a, strides);
        tblis::tblis_init_tensor_d(&tb, 2, lengths, b, strides);
        tblis::tblis_init_tensor_scaled_d(&tc, 0.0, 2, lengths, c, strides);
        tblis_set_num_threads(1);
        tblis::tblis_tensor_mult(tblis_single, nullptr,
                                 &ta, a_labels, &tb, b_labels, &tc, c_labels);

        const double expected[] = {19.0, 22.0, 43.0, 50.0};
        for (int i = 0; i < 4; ++i) {
          if (std::abs(c[i] - expected[i]) > 1.0e-12) return 1;
        }
        return 0;
      }
    CPP

    system ENV.cxx, "-std=c++20", "test.cpp", "-I#{include}", "-L#{lib}",
                    "-ltblis", "-o", "test"
    system "./test"
  end
end
