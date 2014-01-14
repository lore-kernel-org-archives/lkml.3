Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751899AbaANPi0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jan 2014 10:38:26 -0500
Received: from mail-ee0-f52.google.com ([74.125.83.52]:64196 "EHLO
	mail-ee0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751462AbaANPh2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jan 2014 10:37:28 -0500
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        David Ahern <dsahern@gmail.com>, Ingo Molnar <mingo@kernel.org>,
        Jiri Olsa <jolsa@redhat.com>, Namhyung Kim <namhyung@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>
Subject: perf tools: Random cleanups 
Date: Tue, 14 Jan 2014 16:37:13 +0100
Message-Id: <1389713836-13375-1-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.8.3.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Just a bunch of non critical cleanups for comm and callchains. Based on latest acme:perf/core

git://git.kernel.org/pub/scm/linux/kernel/git/frederic/linux-dynticks.git
	perf/core-cleanups-for-acme

Thanks,
	Frederic
---

Frederic Weisbecker (3):
      perf tools: Do proper comm override error handling
      perf tools: Spare double comparison of callchain first entry
      perf tools: Remove unnecessary callchain cursor state restore on unmatch


 tools/perf/util/callchain.c | 23 ++++++++++-------------
 tools/perf/util/comm.c      | 19 ++++++++++---------
 tools/perf/util/comm.h      |  2 +-
 tools/perf/util/thread.c    |  5 ++++-
 4 files changed, 25 insertions(+), 24 deletions(-)
