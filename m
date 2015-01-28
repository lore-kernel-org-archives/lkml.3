Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752891AbbA1Uur (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2015 15:50:47 -0500
Received: from terminus.zytor.com ([198.137.202.10]:40980 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752461AbbA1Uum (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2015 15:50:42 -0500
Date: Wed, 28 Jan 2015 07:03:46 -0800
From: tip-bot for Arnaldo Carvalho de Melo <tipbot@zytor.com>
Message-ID: <tip-u70i7shys3kths4hzru72bha@git.kernel.org>
Cc: hpa@zytor.com, mingo@kernel.org, linux-kernel@vger.kernel.org,
        paulus@samba.org, dsahern@gmail.com, eranian@google.com,
        fweisbec@gmail.com, jolsa@redhat.com, namhyung@kernel.org,
        adrian.hunter@intel.com, tglx@linutronix.de, peterz@infradead.org,
        acme@redhat.com, bp@suse.de, efault@gmx.de, dzickus@redhat.com
Reply-To: mingo@kernel.org, hpa@zytor.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, eranian@google.com, dsahern@gmail.com,
        fweisbec@gmail.com, jolsa@redhat.com, namhyung@kernel.org,
        adrian.hunter@intel.com, tglx@linutronix.de, bp@suse.de, efault@gmx.de,
        peterz@infradead.org, acme@redhat.com, dzickus@redhat.com
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf tools: Remove EOL whitespaces
Git-Commit-ID: 48000a1aed7422a833220245da43114012c355d7
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  48000a1aed7422a833220245da43114012c355d7
Gitweb:     http://git.kernel.org/tip/48000a1aed7422a833220245da43114012c355d7
Author:     Arnaldo Carvalho de Melo <acme@redhat.com>
AuthorDate: Wed, 17 Dec 2014 17:24:45 -0300
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Wed, 21 Jan 2015 13:24:31 -0300

perf tools: Remove EOL whitespaces

Janitorial stuff: boredom moment.

Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: Borislav Petkov <bp@suse.de>
Cc: David Ahern <dsahern@gmail.com>
Cc: Don Zickus <dzickus@redhat.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/n/tip-u70i7shys3kths4hzru72bha@git.kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/Documentation/perf-buildid-cache.txt    |  2 +-
 tools/perf/Documentation/perf-script.txt           | 28 ++++----
 tools/perf/builtin-buildid-cache.c                 |  4 +-
 tools/perf/builtin-stat.c                          |  2 +-
 tools/perf/builtin-top.c                           |  2 +-
 tools/perf/builtin-trace.c                         | 80 +++++++++++-----------
 tools/perf/tests/attr.py                           |  1 -
 tools/perf/tests/make                              |  1 -
 tools/perf/tests/parse-events.c                    |  2 +-
 tools/perf/ui/browsers/annotate.c                  |  3 +-
 tools/perf/ui/progress.h                           |  4 +-
 tools/perf/util/annotate.c                         |  2 +-
 tools/perf/util/parse-events.c                     |  6 +-
 tools/perf/util/python.c                           |  2 +-
 .../util/scripting-engines/trace-event-python.c    |  2 +-
 tools/perf/util/session.c                          |  2 +-
 tools/perf/util/symbol.c                           |  2 +-
 17 files changed, 71 insertions(+), 74 deletions(-)

diff --git a/tools/perf/Documentation/perf-buildid-cache.txt b/tools/perf/Documentation/perf-buildid-cache.txt
index fd77d81..0294c57 100644
--- a/tools/perf/Documentation/perf-buildid-cache.txt
+++ b/tools/perf/Documentation/perf-buildid-cache.txt
@@ -38,7 +38,7 @@ OPTIONS
 --remove=::
         Remove specified file from the cache.
 -M::
---missing=:: 
+--missing=::
 	List missing build ids in the cache for the specified file.
 -u::
 --update::
diff --git a/tools/perf/Documentation/perf-script.txt b/tools/perf/Documentation/perf-script.txt
index 2149480..a21eec0 100644
--- a/tools/perf/Documentation/perf-script.txt
+++ b/tools/perf/Documentation/perf-script.txt
@@ -125,46 +125,46 @@ OPTIONS
 	is equivalent to:
 
 		perf script -f trace:<fields> -f sw:<fields> -f hw:<fields>
-    
+
 	i.e., the specified fields apply to all event types if the type string
 	is not given.
-    
+
 	The arguments are processed in the order received. A later usage can
 	reset a prior request. e.g.:
-    
+
 		-f trace: -f comm,tid,time,ip,sym
-    
+
 	The first -f suppresses trace events (field list is ""), but then the
 	second invocation sets the fields to comm,tid,time,ip,sym. In this case a
 	warning is given to the user:
-    
+
 		"Overriding previous field request for all events."
-    
+
 	Alternatively, consider the order:
-    
+
 		-f comm,tid,time,ip,sym -f trace:
-    
+
 	The first -f sets the fields for all events and the second -f
 	suppresses trace events. The user is given a warning message about
 	the override, and the result of the above is that only S/W and H/W
 	events are displayed with the given fields.
-    
+
 	For the 'wildcard' option if a user selected field is invalid for an
 	event type, a message is displayed to the user that the option is
 	ignored for that type. For example:
-    
+
 		$ perf script -f comm,tid,trace
 		'trace' not valid for hardware events. Ignoring.
 		'trace' not valid for software events. Ignoring.
-    
+
 	Alternatively, if the type is given an invalid field is specified it
 	is an error. For example:
-    
+
         perf script -v -f sw:comm,tid,trace
         'trace' not valid for software events.
-    
+
 	At this point usage is displayed, and perf-script exits.
-    
+
 	Finally, a user may not set fields to none for all event types.
 	i.e., -f "" is not allowed.
 
diff --git a/tools/perf/builtin-buildid-cache.c b/tools/perf/builtin-buildid-cache.c
index 77d5cae..50e6b66 100644
--- a/tools/perf/builtin-buildid-cache.c
+++ b/tools/perf/builtin-buildid-cache.c
@@ -236,10 +236,10 @@ static bool dso__missing_buildid_cache(struct dso *dso, int parm __maybe_unused)
 		if (errno == ENOENT)
 			return false;
 
-		pr_warning("Problems with %s file, consider removing it from the cache\n", 
+		pr_warning("Problems with %s file, consider removing it from the cache\n",
 			   filename);
 	} else if (memcmp(dso->build_id, build_id, sizeof(dso->build_id))) {
-		pr_warning("Problems with %s file, consider removing it from the cache\n", 
+		pr_warning("Problems with %s file, consider removing it from the cache\n",
 			   filename);
 	}
 
diff --git a/tools/perf/builtin-stat.c b/tools/perf/builtin-stat.c
index 8910863..e598e4e 100644
--- a/tools/perf/builtin-stat.c
+++ b/tools/perf/builtin-stat.c
@@ -1730,7 +1730,7 @@ int cmd_stat(int argc, const char **argv, const char *prefix __maybe_unused)
 		    "detailed run - start a lot of events"),
 	OPT_BOOLEAN('S', "sync", &sync_run,
 		    "call sync() before starting a run"),
-	OPT_CALLBACK_NOOPT('B', "big-num", NULL, NULL, 
+	OPT_CALLBACK_NOOPT('B', "big-num", NULL, NULL,
 			   "print large numbers with thousands\' separators",
 			   stat__set_big_num),
 	OPT_STRING('C', "cpu", &target.cpu_list, "cpu",
diff --git a/tools/perf/builtin-top.c b/tools/perf/builtin-top.c
index 616f0fc..c4c7eac 100644
--- a/tools/perf/builtin-top.c
+++ b/tools/perf/builtin-top.c
@@ -165,7 +165,7 @@ static void ui__warn_map_erange(struct map *map, struct symbol *sym, u64 ip)
 		    err ? "[unknown]" : uts.release, perf_version_string);
 	if (use_browser <= 0)
 		sleep(5);
-	
+
 	map->erange_warned = true;
 }
 
diff --git a/tools/perf/builtin-trace.c b/tools/perf/builtin-trace.c
index badfabc..258f655 100644
--- a/tools/perf/builtin-trace.c
+++ b/tools/perf/builtin-trace.c
@@ -929,66 +929,66 @@ static struct syscall_fmt {
 	  .arg_scnprintf = { [0] = SCA_HEX, /* brk */ }, },
 	{ .name     = "clock_gettime",  .errmsg = true, STRARRAY(0, clk_id, clockid), },
 	{ .name	    = "close",	    .errmsg = true,
-	  .arg_scnprintf = { [0] = SCA_CLOSE_FD, /* fd */ }, }, 
+	  .arg_scnprintf = { [0] = SCA_CLOSE_FD, /* fd */ }, },
 	{ .name	    = "connect",    .errmsg = true, },
 	{ .name	    = "dup",	    .errmsg = true,
-	  .arg_scnprintf = { [0] = SCA_FD, /* fd */ }, }, 
+	  .arg_scnprintf = { [0] = SCA_FD, /* fd */ }, },
 	{ .name	    = "dup2",	    .errmsg = true,
-	  .arg_scnprintf = { [0] = SCA_FD, /* fd */ }, }, 
+	  .arg_scnprintf = { [0] = SCA_FD, /* fd */ }, },
 	{ .name	    = "dup3",	    .errmsg = true,
-	  .arg_scnprintf = { [0] = SCA_FD, /* fd */ }, }, 
+	  .arg_scnprintf = { [0] = SCA_FD, /* fd */ }, },
 	{ .name	    = "epoll_ctl",  .errmsg = true, STRARRAY(1, op, epoll_ctl_ops), },
 	{ .name	    = "eventfd2",   .errmsg = true,
 	  .arg_scnprintf = { [1] = SCA_EFD_FLAGS, /* flags */ }, },
 	{ .name	    = "faccessat",  .errmsg = true,
 	  .arg_scnprintf = { [0] = SCA_FDAT, /* dfd */ }, },
 	{ .name	    = "fadvise64",  .errmsg = true,
-	  .arg_scnprintf = { [0] = SCA_FD, /* fd */ }, }, 
+	  .arg_scnprintf = { [0] = SCA_FD, /* fd */ }, },
 	{ .name	    = "fallocate",  .errmsg = true,
-	  .arg_scnprintf = { [0] = SCA_FD, /* fd */ }, }, 
+	  .arg_scnprintf = { [0] = SCA_FD, /* fd */ }, },
 	{ .name	    = "fchdir",	    .errmsg = true,
-	  .arg_scnprintf = { [0] = SCA_FD, /* fd */ }, }, 
+	  .arg_scnprintf = { [0] = SCA_FD, /* fd */ }, },
 	{ .name	    = "fchmod",	    .errmsg = true,
-	  .arg_scnprintf = { [0] = SCA_FD, /* fd */ }, }, 
+	  .arg_scnprintf = { [0] = SCA_FD, /* fd */ }, },
 	{ .name	    = "fchmodat",   .errmsg = true,
-	  .arg_scnprintf = { [0] = SCA_FDAT, /* fd */ }, }, 
+	  .arg_scnprintf = { [0] = SCA_FDAT, /* fd */ }, },
 	{ .name	    = "fchown",	    .errmsg = true,
-	  .arg_scnprintf = { [0] = SCA_FD, /* fd */ }, }, 
+	  .arg_scnprintf = { [0] = SCA_FD, /* fd */ }, },
 	{ .name	    = "fchownat",   .errmsg = true,
-	  .arg_scnprintf = { [0] = SCA_FDAT, /* fd */ }, }, 
+	  .arg_scnprintf = { [0] = SCA_FDAT, /* fd */ }, },
 	{ .name	    = "fcntl",	    .errmsg = true,
 	  .arg_scnprintf = { [0] = SCA_FD, /* fd */
 			     [1] = SCA_STRARRAY, /* cmd */ },
 	  .arg_parm	 = { [1] = &strarray__fcntl_cmds, /* cmd */ }, },
 	{ .name	    = "fdatasync",  .errmsg = true,
-	  .arg_scnprintf = { [0] = SCA_FD, /* fd */ }, }, 
+	  .arg_scnprintf = { [0] = SCA_FD, /* fd */ }, },
 	{ .name	    = "flock",	    .errmsg = true,
 	  .arg_scnprintf = { [0] = SCA_FD, /* fd */
 			     [1] = SCA_FLOCK, /* cmd */ }, },
 	{ .name	    = "fsetxattr",  .errmsg = true,
-	  .arg_scnprintf = { [0] = SCA_FD, /* fd */ }, }, 
+	  .arg_scnprintf = { [0] = SCA_FD, /* fd */ }, },
 	{ .name	    = "fstat",	    .errmsg = true, .alias = "newfstat",
-	  .arg_scnprintf = { [0] = SCA_FD, /* fd */ }, }, 
+	  .arg_scnprintf = { [0] = SCA_FD, /* fd */ }, },
 	{ .name	    = "fstatat",    .errmsg = true, .alias = "newfstatat",
-	  .arg_scnprintf = { [0] = SCA_FDAT, /* dfd */ }, }, 
+	  .arg_scnprintf = { [0] = SCA_FDAT, /* dfd */ }, },
 	{ .name	    = "fstatfs",    .errmsg = true,
-	  .arg_scnprintf = { [0] = SCA_FD, /* fd */ }, }, 
+	  .arg_scnprintf = { [0] = SCA_FD, /* fd */ }, },
 	{ .name	    = "fsync",    .errmsg = true,
-	  .arg_scnprintf = { [0] = SCA_FD, /* fd */ }, }, 
+	  .arg_scnprintf = { [0] = SCA_FD, /* fd */ }, },
 	{ .name	    = "ftruncate", .errmsg = true,
-	  .arg_scnprintf = { [0] = SCA_FD, /* fd */ }, }, 
+	  .arg_scnprintf = { [0] = SCA_FD, /* fd */ }, },
 	{ .name	    = "futex",	    .errmsg = true,
 	  .arg_scnprintf = { [1] = SCA_FUTEX_OP, /* op */ }, },
 	{ .name	    = "futimesat", .errmsg = true,
-	  .arg_scnprintf = { [0] = SCA_FDAT, /* fd */ }, }, 
+	  .arg_scnprintf = { [0] = SCA_FDAT, /* fd */ }, },
 	{ .name	    = "getdents",   .errmsg = true,
-	  .arg_scnprintf = { [0] = SCA_FD, /* fd */ }, }, 
+	  .arg_scnprintf = { [0] = SCA_FD, /* fd */ }, },
 	{ .name	    = "getdents64", .errmsg = true,
-	  .arg_scnprintf = { [0] = SCA_FD, /* fd */ }, }, 
+	  .arg_scnprintf = { [0] = SCA_FD, /* fd */ }, },
 	{ .name	    = "getitimer",  .errmsg = true, STRARRAY(0, which, itimers), },
 	{ .name	    = "getrlimit",  .errmsg = true, STRARRAY(0, resource, rlimit_resources), },
 	{ .name	    = "ioctl",	    .errmsg = true,
-	  .arg_scnprintf = { [0] = SCA_FD, /* fd */ 
+	  .arg_scnprintf = { [0] = SCA_FD, /* fd */
 #if defined(__i386__) || defined(__x86_64__)
 /*
  * FIXME: Make this available to all arches.
@@ -1002,7 +1002,7 @@ static struct syscall_fmt {
 	{ .name	    = "kill",	    .errmsg = true,
 	  .arg_scnprintf = { [1] = SCA_SIGNUM, /* sig */ }, },
 	{ .name	    = "linkat",	    .errmsg = true,
-	  .arg_scnprintf = { [0] = SCA_FDAT, /* fd */ }, }, 
+	  .arg_scnprintf = { [0] = SCA_FDAT, /* fd */ }, },
 	{ .name	    = "lseek",	    .errmsg = true,
 	  .arg_scnprintf = { [0] = SCA_FD, /* fd */
 			     [2] = SCA_STRARRAY, /* whence */ },
@@ -1012,9 +1012,9 @@ static struct syscall_fmt {
 	  .arg_scnprintf = { [0] = SCA_HEX,	 /* start */
 			     [2] = SCA_MADV_BHV, /* behavior */ }, },
 	{ .name	    = "mkdirat",    .errmsg = true,
-	  .arg_scnprintf = { [0] = SCA_FDAT, /* fd */ }, }, 
+	  .arg_scnprintf = { [0] = SCA_FDAT, /* fd */ }, },
 	{ .name	    = "mknodat",    .errmsg = true,
-	  .arg_scnprintf = { [0] = SCA_FDAT, /* fd */ }, }, 
+	  .arg_scnprintf = { [0] = SCA_FDAT, /* fd */ }, },
 	{ .name	    = "mlock",	    .errmsg = true,
 	  .arg_scnprintf = { [0] = SCA_HEX, /* addr */ }, },
 	{ .name	    = "mlockall",   .errmsg = true,
@@ -1036,9 +1036,9 @@ static struct syscall_fmt {
 	{ .name	    = "munmap",	    .errmsg = true,
 	  .arg_scnprintf = { [0] = SCA_HEX, /* addr */ }, },
 	{ .name	    = "name_to_handle_at", .errmsg = true,
-	  .arg_scnprintf = { [0] = SCA_FDAT, /* dfd */ }, }, 
+	  .arg_scnprintf = { [0] = SCA_FDAT, /* dfd */ }, },
 	{ .name	    = "newfstatat", .errmsg = true,
-	  .arg_scnprintf = { [0] = SCA_FDAT, /* dfd */ }, }, 
+	  .arg_scnprintf = { [0] = SCA_FDAT, /* dfd */ }, },
 	{ .name	    = "open",	    .errmsg = true,
 	  .arg_scnprintf = { [1] = SCA_OPEN_FLAGS, /* flags */ }, },
 	{ .name	    = "open_by_handle_at", .errmsg = true,
@@ -1052,20 +1052,20 @@ static struct syscall_fmt {
 	{ .name	    = "poll",	    .errmsg = true, .timeout = true, },
 	{ .name	    = "ppoll",	    .errmsg = true, .timeout = true, },
 	{ .name	    = "pread",	    .errmsg = true, .alias = "pread64",
-	  .arg_scnprintf = { [0] = SCA_FD, /* fd */ }, }, 
+	  .arg_scnprintf = { [0] = SCA_FD, /* fd */ }, },
 	{ .name	    = "preadv",	    .errmsg = true, .alias = "pread",
-	  .arg_scnprintf = { [0] = SCA_FD, /* fd */ }, }, 
+	  .arg_scnprintf = { [0] = SCA_FD, /* fd */ }, },
 	{ .name	    = "prlimit64",  .errmsg = true, STRARRAY(1, resource, rlimit_resources), },
 	{ .name	    = "pwrite",	    .errmsg = true, .alias = "pwrite64",
-	  .arg_scnprintf = { [0] = SCA_FD, /* fd */ }, }, 
+	  .arg_scnprintf = { [0] = SCA_FD, /* fd */ }, },
 	{ .name	    = "pwritev",    .errmsg = true,
-	  .arg_scnprintf = { [0] = SCA_FD, /* fd */ }, }, 
+	  .arg_scnprintf = { [0] = SCA_FD, /* fd */ }, },
 	{ .name	    = "read",	    .errmsg = true,
-	  .arg_scnprintf = { [0] = SCA_FD, /* fd */ }, }, 
+	  .arg_scnprintf = { [0] = SCA_FD, /* fd */ }, },
 	{ .name	    = "readlinkat", .errmsg = true,
-	  .arg_scnprintf = { [0] = SCA_FDAT, /* dfd */ }, }, 
+	  .arg_scnprintf = { [0] = SCA_FDAT, /* dfd */ }, },
 	{ .name	    = "readv",	    .errmsg = true,
-	  .arg_scnprintf = { [0] = SCA_FD, /* fd */ }, }, 
+	  .arg_scnprintf = { [0] = SCA_FD, /* fd */ }, },
 	{ .name	    = "recvfrom",   .errmsg = true,
 	  .arg_scnprintf = { [3] = SCA_MSG_FLAGS, /* flags */ }, },
 	{ .name	    = "recvmmsg",   .errmsg = true,
@@ -1073,7 +1073,7 @@ static struct syscall_fmt {
 	{ .name	    = "recvmsg",    .errmsg = true,
 	  .arg_scnprintf = { [2] = SCA_MSG_FLAGS, /* flags */ }, },
 	{ .name	    = "renameat",   .errmsg = true,
-	  .arg_scnprintf = { [0] = SCA_FDAT, /* dfd */ }, }, 
+	  .arg_scnprintf = { [0] = SCA_FDAT, /* dfd */ }, },
 	{ .name	    = "rt_sigaction", .errmsg = true,
 	  .arg_scnprintf = { [0] = SCA_SIGNUM, /* sig */ }, },
 	{ .name	    = "rt_sigprocmask",  .errmsg = true, STRARRAY(0, how, sighow), },
@@ -1091,7 +1091,7 @@ static struct syscall_fmt {
 	{ .name	    = "setitimer",  .errmsg = true, STRARRAY(0, which, itimers), },
 	{ .name	    = "setrlimit",  .errmsg = true, STRARRAY(0, resource, rlimit_resources), },
 	{ .name	    = "shutdown",   .errmsg = true,
-	  .arg_scnprintf = { [0] = SCA_FD, /* fd */ }, }, 
+	  .arg_scnprintf = { [0] = SCA_FD, /* fd */ }, },
 	{ .name	    = "socket",	    .errmsg = true,
 	  .arg_scnprintf = { [0] = SCA_STRARRAY, /* family */
 			     [1] = SCA_SK_TYPE, /* type */ },
@@ -1102,7 +1102,7 @@ static struct syscall_fmt {
 	  .arg_parm	 = { [0] = &strarray__socket_families, /* family */ }, },
 	{ .name	    = "stat",	    .errmsg = true, .alias = "newstat", },
 	{ .name	    = "symlinkat",  .errmsg = true,
-	  .arg_scnprintf = { [0] = SCA_FDAT, /* dfd */ }, }, 
+	  .arg_scnprintf = { [0] = SCA_FDAT, /* dfd */ }, },
 	{ .name	    = "tgkill",	    .errmsg = true,
 	  .arg_scnprintf = { [2] = SCA_SIGNUM, /* sig */ }, },
 	{ .name	    = "tkill",	    .errmsg = true,
@@ -1113,9 +1113,9 @@ static struct syscall_fmt {
 	{ .name	    = "utimensat",  .errmsg = true,
 	  .arg_scnprintf = { [0] = SCA_FDAT, /* dirfd */ }, },
 	{ .name	    = "write",	    .errmsg = true,
-	  .arg_scnprintf = { [0] = SCA_FD, /* fd */ }, }, 
+	  .arg_scnprintf = { [0] = SCA_FD, /* fd */ }, },
 	{ .name	    = "writev",	    .errmsg = true,
-	  .arg_scnprintf = { [0] = SCA_FD, /* fd */ }, }, 
+	  .arg_scnprintf = { [0] = SCA_FD, /* fd */ }, },
 };
 
 static int syscall_fmt__cmp(const void *name, const void *fmtp)
@@ -1191,7 +1191,7 @@ static struct thread_trace *thread__trace(struct thread *thread, FILE *fp)
 
 	if (thread__priv(thread) == NULL)
 		thread__set_priv(thread, thread_trace__new());
-		
+
 	if (thread__priv(thread) == NULL)
 		goto fail;
 
diff --git a/tools/perf/tests/attr.py b/tools/perf/tests/attr.py
index c9b4b62..1091bd4 100644
--- a/tools/perf/tests/attr.py
+++ b/tools/perf/tests/attr.py
@@ -104,7 +104,6 @@ class Event(dict):
                 continue
             if not self.compare_data(self[t], other[t]):
 		log.warning("expected %s=%s, got %s" % (t, self[t], other[t]))
-                
 
 # Test file description needs to have following sections:
 # [config]
diff --git a/tools/perf/tests/make b/tools/perf/tests/make
index 69a71ff..75709d2 100644
--- a/tools/perf/tests/make
+++ b/tools/perf/tests/make
@@ -222,7 +222,6 @@ tarpkg:
 	@cmd="$(PERF)/tests/perf-targz-src-pkg $(PERF)"; \
 	echo "- $@: $$cmd" && echo $$cmd > $@ && \
 	( eval $$cmd ) >> $@ 2>&1
-	
 
 all: $(run) $(run_O) tarpkg
 	@echo OK
diff --git a/tools/perf/tests/parse-events.c b/tools/perf/tests/parse-events.c
index 7f2f51f..d188e20 100644
--- a/tools/perf/tests/parse-events.c
+++ b/tools/perf/tests/parse-events.c
@@ -1471,7 +1471,7 @@ static int test_event(struct evlist_test *e)
 	} else {
 		ret = e->check(evlist);
 	}
-	
+
 	perf_evlist__delete(evlist);
 
 	return ret;
diff --git a/tools/perf/ui/browsers/annotate.c b/tools/perf/ui/browsers/annotate.c
index 1e0a2fd..9d32e3c 100644
--- a/tools/perf/ui/browsers/annotate.c
+++ b/tools/perf/ui/browsers/annotate.c
@@ -517,7 +517,7 @@ static bool annotate_browser__jump(struct annotate_browser *browser)
 	}
 
 	annotate_browser__set_top(browser, dl, idx);
-	
+
 	return true;
 }
 
@@ -867,7 +867,6 @@ static void annotate_browser__mark_jump_targets(struct annotate_browser *browser
 
 		++browser->nr_jumps;
 	}
-		
 }
 
 static inline int width_jumps(int n)
diff --git a/tools/perf/ui/progress.h b/tools/perf/ui/progress.h
index f34f89e..717d39d 100644
--- a/tools/perf/ui/progress.h
+++ b/tools/perf/ui/progress.h
@@ -4,12 +4,12 @@
 #include <linux/types.h>
 
 void ui_progress__finish(void);
- 
+
 struct ui_progress {
 	const char *title;
 	u64 curr, next, step, total;
 };
- 
+
 void ui_progress__init(struct ui_progress *p, u64 total, const char *title);
 void ui_progress__update(struct ui_progress *p, u64 adv);
 
diff --git a/tools/perf/util/annotate.c b/tools/perf/util/annotate.c
index 01bc4e2..61bf912 100644
--- a/tools/perf/util/annotate.c
+++ b/tools/perf/util/annotate.c
@@ -239,7 +239,7 @@ static int mov__parse(struct ins_operands *ops)
 	*s = '\0';
 	ops->source.raw = strdup(ops->raw);
 	*s = ',';
-	
+
 	if (ops->source.raw == NULL)
 		return -1;
 
diff --git a/tools/perf/util/parse-events.c b/tools/perf/util/parse-events.c
index 77b43fe..f36b80e 100644
--- a/tools/perf/util/parse-events.c
+++ b/tools/perf/util/parse-events.c
@@ -1121,7 +1121,7 @@ void print_tracepoint_events(const char *subsys_glob, const char *event_glob,
 		return;
 
 	for_each_subsystem(sys_dir, sys_dirent, sys_next) {
-		if (subsys_glob != NULL && 
+		if (subsys_glob != NULL &&
 		    !strglobmatch(sys_dirent.d_name, subsys_glob))
 			continue;
 
@@ -1132,7 +1132,7 @@ void print_tracepoint_events(const char *subsys_glob, const char *event_glob,
 			continue;
 
 		for_each_event(sys_dirent, evt_dir, evt_dirent, evt_next) {
-			if (event_glob != NULL && 
+			if (event_glob != NULL &&
 			    !strglobmatch(evt_dirent.d_name, event_glob))
 				continue;
 
@@ -1305,7 +1305,7 @@ static void print_symbol_events(const char *event_glob, unsigned type,
 
 	for (i = 0; i < max; i++, syms++) {
 
-		if (event_glob != NULL && 
+		if (event_glob != NULL &&
 		    !(strglobmatch(syms->symbol, event_glob) ||
 		      (syms->alias && strglobmatch(syms->alias, event_glob))))
 			continue;
diff --git a/tools/perf/util/python.c b/tools/perf/util/python.c
index 3dda85c..d906d0a 100644
--- a/tools/perf/util/python.c
+++ b/tools/perf/util/python.c
@@ -768,7 +768,7 @@ static PyObject *pyrf_evlist__get_pollfd(struct pyrf_evlist *pevlist,
 			Py_DECREF(file);
 			goto free_list;
 		}
-			
+
 		Py_DECREF(file);
 	}
 
diff --git a/tools/perf/util/scripting-engines/trace-event-python.c b/tools/perf/util/scripting-engines/trace-event-python.c
index d808a32..0c815a4 100644
--- a/tools/perf/util/scripting-engines/trace-event-python.c
+++ b/tools/perf/util/scripting-engines/trace-event-python.c
@@ -89,7 +89,7 @@ static void handler_call_die(const char *handler_name)
 
 /*
  * Insert val into into the dictionary and decrement the reference counter.
- * This is necessary for dictionaries since PyDict_SetItemString() does not 
+ * This is necessary for dictionaries since PyDict_SetItemString() does not
  * steal a reference, as opposed to PyTuple_SetItem().
  */
 static void pydict_set_item_string_decref(PyObject *dict, const char *key, PyObject *val)
diff --git a/tools/perf/util/session.c b/tools/perf/util/session.c
index 5f0e05a..b0ce3d6 100644
--- a/tools/perf/util/session.c
+++ b/tools/perf/util/session.c
@@ -274,7 +274,7 @@ void perf_tool__fill_defaults(struct perf_tool *tool)
 	if (tool->id_index == NULL)
 		tool->id_index = process_id_index_stub;
 }
- 
+
 static void swap_sample_id_all(union perf_event *event, void *data)
 {
 	void *end = (void *) event + event->header.size;
diff --git a/tools/perf/util/symbol.c b/tools/perf/util/symbol.c
index a194702..a690668 100644
--- a/tools/perf/util/symbol.c
+++ b/tools/perf/util/symbol.c
@@ -685,7 +685,7 @@ static int dso__split_kallsyms(struct dso *dso, struct map *map, u64 delta,
 	struct machine *machine = kmaps->machine;
 	struct map *curr_map = map;
 	struct symbol *pos;
-	int count = 0, moved = 0;	
+	int count = 0, moved = 0;
 	struct rb_root *root = &dso->symbols[map->type];
 	struct rb_node *next = rb_first(root);
 	int kernel_range = 0;
