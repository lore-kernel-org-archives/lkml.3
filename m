Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751660AbaJRHHx (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Oct 2014 03:07:53 -0400
Received: from terminus.zytor.com ([198.137.202.10]:51667 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750937AbaJRHHs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Oct 2014 03:07:48 -0400
Date: Sat, 18 Oct 2014 00:06:53 -0700
From: tip-bot for Arnaldo Carvalho de Melo <tipbot@zytor.com>
Message-ID: <tip-xsvxr747wkkpg1ay9dramorr@git.kernel.org>
Cc: jean.pihet@linaro.org, mingo@kernel.org, tglx@linutronix.de,
        paulus@samba.org, hpa@zytor.com, dzickus@redhat.com, bp@suse.de,
        adrian.hunter@intel.com, linux-kernel@vger.kernel.org,
        jolsa@redhat.com, namhyung@kernel.org, fweisbec@gmail.com,
        efault@gmx.de, eranian@google.com, peterz@infradead.org,
        dsahern@gmail.com, acme@redhat.com
Reply-To: hpa@zytor.com, paulus@samba.org, adrian.hunter@intel.com, bp@suse.de,
        dzickus@redhat.com, tglx@linutronix.de, jean.pihet@linaro.org,
        mingo@kernel.org, acme@redhat.com, dsahern@gmail.com,
        peterz@infradead.org, eranian@google.com, efault@gmx.de,
        fweisbec@gmail.com, linux-kernel@vger.kernel.org, namhyung@kernel.org,
        jolsa@redhat.com
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] perf evlist: Add missing 'struct option'
  forward declaration
Git-Commit-ID: 724ce97e9f8616ffb62b940f3726685c6f31f9b9
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

Commit-ID:  724ce97e9f8616ffb62b940f3726685c6f31f9b9
Gitweb:     http://git.kernel.org/tip/724ce97e9f8616ffb62b940f3726685c6f31f9b9
Author:     Arnaldo Carvalho de Melo <acme@redhat.com>
AuthorDate: Fri, 17 Oct 2014 12:16:00 -0300
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Fri, 17 Oct 2014 12:16:00 -0300

perf evlist: Add missing 'struct option' forward declaration

It was being found, by chance, because evsel.h needlessly includes
util/cgroup.h, which will be sorted out in a following patch.

Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: Borislav Petkov <bp@suse.de>
Cc: David Ahern <dsahern@gmail.com>
Cc: Don Zickus <dzickus@redhat.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Jean Pihet <jean.pihet@linaro.org>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/n/tip-xsvxr747wkkpg1ay9dramorr@git.kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/evlist.h | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/tools/perf/util/evlist.h b/tools/perf/util/evlist.h
index bd312b0..649b0c5 100644
--- a/tools/perf/util/evlist.h
+++ b/tools/perf/util/evlist.h
@@ -117,6 +117,8 @@ int perf_evlist__prepare_workload(struct perf_evlist *evlist,
 						     void *ucontext));
 int perf_evlist__start_workload(struct perf_evlist *evlist);
 
+struct option;
+
 int perf_evlist__parse_mmap_pages(const struct option *opt,
 				  const char *str,
 				  int unset);
