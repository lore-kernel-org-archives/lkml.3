Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754941Ab3ILQkA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Sep 2013 12:40:00 -0400
Received: from mx1.redhat.com ([209.132.183.28]:20943 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754920Ab3ILQj6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Sep 2013 12:39:58 -0400
From: Jiri Olsa <jolsa@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Namhyung Kim <namhyung@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        David Ahern <dsahern@gmail.com>
Subject: [PATCH 0/4] perf tools: Misc fixies
Date: Thu, 12 Sep 2013 18:39:32 +0200
Message-Id: <1379003976-5839-1-git-send-email-jolsa@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

hi,
sending misc standalone fixies from plugins support patchset,
plus one extra kmem command fix.

available at:
git://git.kernel.org/pub/scm/linux/kernel/git/jolsa/perf.git
perf/core_file

thanks,
jirka


Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: David Ahern <dsahern@gmail.com>
---
Jiri Olsa (4):
      perf tools: Fix 'make install prefix=...' build rule
      perf tools: Remove unused trace-event-* code
      perf tools: Unify page_size usage
      perf tools: Make kmem work for non numa machines

 tools/perf/Makefile                 |  1 +
 tools/perf/builtin-kmem.c           |  2 +-
 tools/perf/builtin-record.c         |  5 +----
 tools/perf/perf.c                   |  1 +
 tools/perf/util/python.c            |  1 +
 tools/perf/util/trace-event-parse.c | 36 ------------------------------------
 tools/perf/util/trace-event.h       |  9 ---------
 7 files changed, 5 insertions(+), 50 deletions(-)
