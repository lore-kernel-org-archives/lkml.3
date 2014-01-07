Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757124AbaAGDAR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jan 2014 22:00:17 -0500
Received: from LGEMRELSE6Q.lge.com ([156.147.1.121]:42663 "EHLO
	LGEMRELSE6Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754992AbaAGDAQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jan 2014 22:00:16 -0500
X-AuditID: 9c930179-b7c89ae000006438-b4-52cb6dbd6dcf
From: Namhyung Kim <namhyung@kernel.org>
To: Steven Rostedt <rostedt@goodmis.org>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Ingo Molnar <mingo@kernel.org>, Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>, Jiri Olsa <jolsa@redhat.com>
Subject: [PATCHSET 0/5] tools lib traceevent: Get rid of *die() calls finally!! (v2)
Date: Tue,  7 Jan 2014 12:00:07 +0900
Message-Id: <1389063612-18173-1-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 1.7.11.7
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

I've added WARN_ONCE in TRACE_SEQ_CHECK() as Jiri said.  Other patches
are same as the privous version.

You can also get this on my 'libtraceevent/die-removal-v5' branch in my tree

  git://git.kernel.org/pub/scm/linux/kernel/git/namhyung/linux-perf.git


Thanks,
Namhyung


Namhyung Kim (5):
  tools lib traceevent: Add WARN and WARN_ONCE macros
  tools lib traceevent: Add state member to struct trace_seq
  tools lib traceevent: Check return value of realloc()
  tools lib traceevent: Get rid of malloc_or_die() in trace_seq_init()
  tools lib traceevent: Get rid of die() finally!!

 tools/lib/traceevent/event-parse.h |  7 +++++
 tools/lib/traceevent/event-utils.h | 26 ++++++++++++++---
 tools/lib/traceevent/parse-utils.c | 44 -----------------------------
 tools/lib/traceevent/trace-seq.c   | 57 +++++++++++++++++++++++++++++++++-----
 4 files changed, 79 insertions(+), 55 deletions(-)

-- 
1.7.11.7

