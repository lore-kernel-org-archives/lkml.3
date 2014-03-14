Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756482AbaCNRYY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Mar 2014 13:24:24 -0400
Received: from merlin.infradead.org ([205.233.59.134]:48293 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756441AbaCNRYW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Mar 2014 13:24:22 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@kernel.org>,
        Patrick Palka <patrick@parcs.ath.cx>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>
Subject: [GIT PULL 0/2] perf/urgent 'perf bench' fixes
Date: Fri, 14 Mar 2014 14:23:57 -0300
Message-Id: <1394817839-26310-1-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.8.1.4
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by merlin.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

Hi Ingo,

	Please consider pulling,

- Arnaldo

The following changes since commit b7b4839d93e50adccef29eccb694807cdcb8bee3:

  perf/x86: Fix leak in uncore_type_init failure paths (2014-03-11 11:59:34 +0100)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/acme/linux tags/perf-urgent-for-mingo

for you to fetch changes up to 6eeefccdcfc2cc9697562e740bfe6c35fddd4e1c:

  perf bench: Fix NULL pointer dereference in "perf bench all" (2014-03-14 13:45:54 -0300)

----------------------------------------------------------------
perf/urgent 'bench' fixes:

. Make 'perf bench mem' (i.e. no args) mean 'run all tests' so that we can run
  all tests, not stopping at the numa ones.  (Arnaldo Carvalho de Melo)

. Fix NULL pointer dereference after last test in in "perf bench all" (Patrick Palka)

Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>

----------------------------------------------------------------
Arnaldo Carvalho de Melo (1):
      perf bench numa: Make no args mean 'run all tests'

Patrick Palka (1):
      perf bench: Fix NULL pointer dereference in "perf bench all"

 tools/perf/bench/numa.c    | 1 +
 tools/perf/builtin-bench.c | 2 +-
 2 files changed, 2 insertions(+), 1 deletion(-)
