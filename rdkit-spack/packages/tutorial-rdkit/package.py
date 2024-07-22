# Copyright 2013-2024 Lawrence Livermore National Security, LLC and other
# Spack Project Developers. See the top-level COPYRIGHT file for details.
#
# SPDX-License-Identifier: (Apache-2.0 OR MIT)

# ----------------------------------------------------------------------------
# If you submit this package back to Spack as a pull request,
# please first remove this boilerplate and all FIXME comments.
#
# This is a template package file for Spack.  We've put "FIXME"
# next to all the things you'll want to change. Once you've handled
# them, you can save this file and test your package like this:
#
#     spack install tutorial-rdkit
#
# You can edit this file again by typing:
#
#     spack edit tutorial-rdkit
#
# See the Spack documentation for more information on packaging.
# ----------------------------------------------------------------------------

from spack.package import *


class TutorialRdkit(CMakePackage):
    """A Computational chemistry tool"""

    homepage = "https://www.rdkit.org"
    url = "https://github.com/sanciop/rdkit/archive/refs/tags/1.0-tutorial.tar.gz"

    maintainers("ptosco")

    license("Bsd-3", checked_by="Ptosco")

    version(
        "1.0-tutorial",
        sha256="9d1f9ce57a3d5f9b30488553933a2ec705d7e3f5e65c182e4f7df53562a60d8c",
    )


    with when("@1.0-tutorial:"):
        depends_on("boost@1.85 +serialization +python +iostreams +system +numpy")
        depends_on("python@3")
        depends_on("sqlite")
        extends("python@3")
    
    variant("wrappers", default=True, description="Generate python wrappers")
    variant("coordgen", default=True)
    variant("contrib", default=False)
    variant("debug", default=False)


    def cmake_args(self):
        args = [self.define("RDK_INSTALL_INTREE", False)]
        # when("+debug"):
        # args.extend([self.define("CMAKE_CXX_FLAGS", "-O0 -g")]
        with when("@1.0-tutorial:"):
            args.extend(
                [
                    self.define_from_variant("RDK_BUILD_PYTHON_WRAPPERS", "wrappers"),
                    self.define_from_variant("RDK_BUILD_CONTRIB", "contrib"),
                    self.define_from_variant("RDK_BUILD_COORDGEN_SUPPORT", "coordgen"),
                ]
            )
        return args
