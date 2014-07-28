Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753187AbaG1PCQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2014 11:02:16 -0400
Received: from mx1.redhat.com ([209.132.183.28]:17465 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753132AbaG1PCL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2014 11:02:11 -0400
From: Jiri Olsa <jolsa@kernel.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@kernel.org>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Namhyung Kim <namhyung@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Jiri Olsa <jolsa@kernel.org>
Subject: [GIT PULL 0/2] perf/core improvements and fixes
Date: Mon, 28 Jul 2014 17:01:00 +0200
Message-Id: <1406559662-4376-1-git-send-email-jolsa@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

hi Ingo,
please consider pulling

thanks,
jirka


The following changes since commit 068f1d3f45546f4bb24e9be67231db1be296f0c8:

  Merge tag 'perf-core-for-mingo' of git://git.kernel.org/pub/scm/linux/kernel/git/acme/linux into perf/core (2014-07-28 10:09:03 +0200)

are available in the git repository at:


  git://git.kernel.org/pub/scm/linux/kernel/git/jolsa/perf.git tags/perf-core-for-mingo

for you to fetch changes up to 8578b891ec38c39abd5d6376afd05fce78e2628c:

  Revert "perf tools: Fix jump label always changing during tracing" (2014-07-28 16:39:18 +0200)

----------------------------------------------------------------
perf/core improvements and fixes:

. Fix perf usage string leftover (Jiri Olsa)

. Revert "perf tools: Fix jump label always changing during tracing" (Jiri Olsa)

Signed-off-by: Jiri Olsa <jolsa@kernel.org>

----------------------------------------------------------------
Jiri Olsa (2):
      perf tools: Fix perf usage string leftover
      Revert "perf tools: Fix jump label always changing during tracing"

 tools/perf/perf.c         | 2 +-
 tools/perf/util/cloexec.c | 9 ++-------
 2 files changed, 3 insertions(+), 8 deletions(-)
