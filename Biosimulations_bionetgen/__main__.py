""" BioSimulations-compliant command-line interface to the `BioNetGen <https://bionetgen.org/>`_ simulation program.

:Author: Jonathan Karr <karr@mssm.edu>
:Date: 2020-04-13
:Copyright: 2020, Center for Reproducible Biomedical Modeling
:License: MIT
"""

from .core import exec_combine_archive
import Biosimulations_bionetgen
import cement


class BaseController(cement.Controller):
    """ Base controller for command line application """

    class Meta:
        label = 'base'
        description = "BioSimulations-compliant command-line interface to the BioNetGen simulation program <https://bionetgen.org>."
        help = "bionetgen"
        arguments = [
            (['-i', '--archive'], dict(type=str,
                                       required=True,
                                       help='Path to OMEX file which contains one or more SED-ML-encoded simulation experiments')),
            (['-o', '--out-dir'], dict(type=str,
                                       default='.',
                                       help='Directory to save outputs')),
            (['-v', '--version'], dict(action='version',
                                       version=Biosimulations_bionetgen.__version__)),
        ]

    @cement.ex(hide=True)
    def _default(self):
        args = self.app.pargs
        exec_combine_archive(args.archive, args.out_dir)


class App(cement.App):
    """ Command line application """
    class Meta:
        label = 'bionetgen'
        base_controller = 'base'
        handlers = [
            BaseController,
        ]


def main():
    with App() as app:
        app.run()
