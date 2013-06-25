Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751492Ab3FYLyw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jun 2013 07:54:52 -0400
Received: from mx1.redhat.com ([209.132.183.28]:64423 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750839Ab3FYLyt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jun 2013 07:54:49 -0400
From: Jiri Olsa <jolsa@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Namhyung Kim <namhyung@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Andi Kleen <ak@linux.intel.com>, David Ahern <dsahern@gmail.com>,
        Stephane Eranian <eranian@google.com>
Subject: [PATCH 0/5] perf tools: Parent option related fixies for report
Date: Tue, 25 Jun 2013 13:54:08 +0200
Message-Id: <1372161253-22081-1-git-send-email-jolsa@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

hi,
sending fixies for parent option in report command
pluhs one unrelated oneliner.

thanks,
jirka

Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Andi Kleen <ak@linux.intel.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Stephane Eranian <eranian@google.com>
---
Jiri Olsa (5):
      perf tools: Remove callchain_cursor_reset call
      perf tools: Fix -x/--exclude-other option for report command
      perf tools: Do not elide parent symbol column
      perf tools: Introduce new -P/--parent-deep report option
      perf tools: Fix perf_session__delete removal for report command

 tools/perf/Documentation/perf-report.txt |  5 +++++
 tools/perf/builtin-diff.c                |  1 -
 tools/perf/builtin-report.c              | 46 ++++++++++++++++++----------------------------
 tools/perf/builtin-top.c                 |  2 --
 tools/perf/util/machine.c                |  6 +++---
 tools/perf/util/symbol.c                 |  1 -
 tools/perf/util/symbol.h                 |  3 ++-
 7 files changed, 28 insertions(+), 36 deletions(-)
