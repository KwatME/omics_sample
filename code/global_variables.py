from os.path import abspath, dirname, join
from pprint import pprint

from kraft import read_json

PROJECT_DIRECTORY_PATH = dirname(dirname(abspath(__file__)))

CODE_DIRECTORY_PATH = join(PROJECT_DIRECTORY_PATH, "code")

INPUT_DIRECTORY_PATH = join(PROJECT_DIRECTORY_PATH, "input")

OUTPUT_DIRECTORY_PATH = join(PROJECT_DIRECTORY_PATH, "output")

DATA_DIRECTORY_PATH = join(INPUT_DIRECTORY_PATH, "data_for_sequencing_process")
DATA_DIRECTORY_PATH = "/media/kwat/CarrotCake/data/"

SAMPLE_DIRECTORY_PATH = join(INPUT_DIRECTORY_PATH, "sample")

SUMMARY_DIRECTORY_PATH = join(OUTPUT_DIRECTORY_PATH, "summary")

PROJECT_JSON = read_json(join(PROJECT_DIRECTORY_PATH, "project.json"))

pprint(PROJECT_JSON)

OUTPUT_GERM_DNA_DIRECTORY_PATH = join(OUTPUT_DIRECTORY_PATH, "germ_dna")

OUTPUT_SOMA_DNA_DIRECTORY_PATH = join(OUTPUT_DIRECTORY_PATH, "soma_dna")

OUTPUT_SOMA_RNA_DIRECTORY_PATH = join(OUTPUT_DIRECTORY_PATH, "soma_rna")
