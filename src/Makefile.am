AM_CPPFLAGS = \
	$(GITHUB_CONTEST_CFLAGS) \
	-include $(CONFIG_HEADER)

BUILT_SOURCES = github-contest.vala.stamp

bin_PROGRAMS = github-contest

github_contest_VALASOURCES = \
	main.vala

github_contest_SOURCES = \
	$(github_contest_VALASOURCES:.vala=.c) \
	$(github_contest_VALASOURCES:.vala=.h)

github-contest.vala.stamp: $(github_contest_VALASOURCES)
	$(VALAC) -C --pkg gio-2.0 --pkg gee-1.0 --basedir $(top_srcdir)/src $^
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

