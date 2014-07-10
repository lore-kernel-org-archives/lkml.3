Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752189AbaGJVHU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2014 17:07:20 -0400
Received: from mx1.redhat.com ([209.132.183.28]:65306 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751019AbaGJVHR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2014 17:07:17 -0400
From: Jiri Olsa <jolsa@kernel.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@kernel.org>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Namhyung Kim <namhyung@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Stanislav Fomichev <stfomichev@yandex-team.ru>,
        Jiri Olsa <jolsa@kernel.org>
Subject: [GIT PULL 0/4] perf/core improvements and fixes
Date: Thu, 10 Jul 2014 23:06:53 +0200
Message-Id: <1405026417-9094-1-git-send-email-jolsa@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

hi Ingo,
please consider pulling

thanks,
jirka


The following changes since commit 8b5b584daf3b92fc5cdc83919e64231817d2f5a7:

  Merge tag 'perf-core-for-mingo' of git://git.kernel.org/pub/scm/linux/kernel/git/jolsa/perf into perf/core (2014-07-05 11:29:32 +0200)

are available in the git repository at:


  git://git.kernel.org/pub/scm/linux/kernel/git/jolsa/perf.git tags/perf-core-for-mingo

for you to fetch changes up to d243144af0b52fc5164a0823194f29a5979e236c:

  perf timechart: Add more options to IO mode (2014-07-10 00:22:54 +0200)

----------------------------------------------------------------
perf/core improvements and fixes:

. Add IO mode into timechart command (Stanislav Fomichev)

Signed-off-by: Jiri Olsa <jolsa@kernel.org>

----------------------------------------------------------------
Stanislav Fomichev (4):
      perf timechart: Fix rendering in Firefox
      perf timechart: Implement IO mode
      perf timechart: Conditionally update start_time on fork
      perf timechart: Add more options to IO mode

 tools/perf/Documentation/perf-timechart.txt |  38 +-
 tools/perf/builtin-timechart.c              | 693 +++++++++++++++++++++++++++-
 tools/perf/util/svghelper.c                 | 168 +++++--
 tools/perf/util/svghelper.h                 |   6 +-
 4 files changed, 845 insertions(+), 60 deletions(-)
