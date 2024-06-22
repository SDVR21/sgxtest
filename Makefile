ARCH_LIBDIR ?= /lib/$(shell $(CC) -dumpmachine)

ifeq ($(DEBUG),1)
GRAMINE_LOG_LEVEL = debug
else
GRAMINE_LOG_LEVEL = error
endif

.PHONY: all
all: alpamon

.PHONY: alpamon
alpamon: alpamon.manifest alpamon.manifest.sgx alpamon.sig

RA_TYPE ?= epid
RA_CLIENT_SPID ?= 70CB9F1E57ED4DAAD11474E7BF2254C1
RA_CLIENT_LINKABLE ?= 1

alpamon.manifest: alpamon.manifest.template
	gramine-manifest \
		-Dlog_level=$(GRAMINE_LOG_LEVEL) \
		-Darch_libdir=$(ARCH_LIBDIR) \
		-Dentrypoint=$(realpath $(shell sh -c "command -v python3")) \
		-Dra_type=$(RA_TYPE) \
		-Dra_client_spid=$(RA_CLIENT_SPID) \
		-Dra_client_linkable=$(RA_CLIENT_LINKABLE) \
		$< >$@

# Make on Ubuntu <= 20.04 doesn't support "Rules with Grouped Targets" (`&:`),
# see the helloworld example for details on this workaround.
alpamon.manifest.sgx alpamon.sig: sgx_sign
	@:

.INTERMEDIATE: sgx_sign
sgx_sign: alpamon.manifest
	gramine-sgx-sign \
		--manifest $< \
		--output $<.sgx

.PHONY: clean
clean:
	$(RM) *.manifest *.manifest.sgx *.token *.sig OUTPUT* *.PID TEST_STDOUT TEST_STDERR log *.report *.quote
	$(RM) -r scripts/__pycache__

.PHONY: distclean
distclean: clean
