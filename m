Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752668AbaDRKcd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Apr 2014 06:32:33 -0400
Received: from mx1.redhat.com ([209.132.183.28]:6673 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751370AbaDRKcZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Apr 2014 06:32:25 -0400
From: Jiri Olsa <jolsa@redhat.com>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        David Ahern <dsahern@gmail.com>, Don Zickus <dzickus@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Li Zefan <lizf@cn.fujitsu.com>, Namhyung Kim <namhyung@kernel.org>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [GIT PULL 0/5] perf/core improvements and fixes
Date: Fri, 18 Apr 2014 12:31:54 +0200
Message-Id: <1397817119-15195-1-git-send-email-jolsa@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

hi Ingo,
please consider pulling

thanks,
jirka


The following changes since commit 37b6cb475a6d74bc047c53bc323d6eb3113e27a4:

  Merge branch 'uprobes/core' of git://git.kernel.org/pub/scm/linux/kernel/git/oleg/misc into perf/core (2014-04-18 09:49:14 +0200)

are available in the git repository at:


  git://git.kernel.org/pub/scm/linux/kernel/git/jolsa/perf.git tags/perf-core-for-mingo

for you to fetch changes up to a651d9357f936a19ae811a29d031224cdb8c2f1f:

  perf callchain: Add generic report parse callchain callback function (2014-04-18 11:56:59 +0200)

----------------------------------------------------------------
perf/core improvements and fixes:

Developer stuff:

. Making some code (cpu node map and report parse callchain callback) global
  to be usable by upcomming changes (Don Zickus)

. Fix pmu object compilation error (Jiri Olsa)

----------------------------------------------------------------
Don Zickus (4):
      perf tools: Allow ability to map cpus to nodes easily
      perf tools: Use cpu/possible instead of cpu/kernel_max
      perf kmem: Utilize the new generic cpunode_map
      perf callchain: Add generic report parse callchain callback function

Jiri Olsa (1):
      perf tools: Fix pmu object compilation error

 tools/perf/builtin-kmem.c   |  78 +----------------------
 tools/perf/builtin-report.c |  81 +-----------------------
 tools/perf/util/callchain.c |  82 ++++++++++++++++++++++++
 tools/perf/util/callchain.h |   1 +
 tools/perf/util/cpumap.c    | 147 ++++++++++++++++++++++++++++++++++++++++++++
 tools/perf/util/cpumap.h    |  35 +++++++++++
 tools/perf/util/pmu.c       |   6 +-
 7 files changed, 274 insertions(+), 156 deletions(-)
