NULL = 

AM_CPPFLAGS = \
	$(GITHUB_CONTEST_CFLAGS) \
	-include $(CONFIG_HEADER) \
	$(NULL)

BUILT_SOURCES = github-contest.vala.stamp

bin_PROGRAMS = github-contest

github_contest_VALASOURCES = \
	main.vala \
	$(NULL)

github_contest_SOURCES = \
	$(github_contest_VALASOURCES:.vala=.c) \
	$(github_contest_VALASOURCES:.vala=.h) \
	$(NULL)

github-contest.vala.stamp: $(github_contest_VALASOURCES)
	$(VALAC) -C --basedir $(top_srcdir)/src $^
	touch $@

github_contest_LDADD = \
	$(GITHUB_CONTEST_LIBS) \
	$(NULL)

EXTRA_DIST = \
	$(github_contest_VALASOURCES) \
	github-contest.vala.stamp \
	$(NULL)

DISTCLEANFILES = \
	$(NULL)

