# Define variables for directories
DATA_DIR := data
RESULTS_DIR := results
FIGURES_DIR := $(RESULTS_DIR)/figure
REPORT_DIR := report

TEXTS := $(wildcard $(DATA_DIR)/*.txt)
PLOTS := $(patsubst $(DATA_DIR)/%.txt, $(FIGURES_DIR)/%.png, $(TEXTS))

# Default target
all: $(PLOTS) $(REPORT_DIR)/_build/html/index.html

# Pattern rule for word count
$(RESULTS_DIR)/%.dat: $(DATA_DIR)/%.txt
	python scripts/wordcount.py --input_file=$< --output_file=$@

# Pattern rule for plot count
$(FIGURES_DIR)/%.png: $(RESULTS_DIR)/%.dat
	python scripts/plotcount.py --input_file=$< --output_file=$@

# Target for report
$(REPORT_DIR)/_build/html/index.html: $(PLOTS)
	jupyter-book build $(REPORT_DIR)

# Clean target
clean:
	rm -f $(RESULTS_DIR)/*.dat
	rm -f $(FIGURES_DIR)/*.png
	rm -rf $(REPORT_DIR)/_build

# Phony targets
.PHONY: all clean
