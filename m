Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752410Ab3JUCqg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Oct 2013 22:46:36 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.225]:22710 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752267Ab3JUCqd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Oct 2013 22:46:33 -0400
Message-Id: <20131021024429.189874455@goodmis.org>
User-Agent: quilt/0.60-1
Date: Sun, 20 Oct 2013 22:44:29 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@kernel.org>, Frederic Weisbecker <fweisbec@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [for-next][PATCH 0/6] tracing: Various updates
X-RR-Connecting-IP: 107.14.168.130:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This has been a long time coming. I'm sure there's more patches that
I missed, as my inbox got a bit large while I worked on some internal
stuff.

Anyway, I got this part out. If you sent me a patch and it's not here,
please ping me again, otherwise I'll probably miss the 3.12 window for it.
I will get to it eventually, but there's a lot of noise to sort through.

-- Steve

  git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-trace.git
for-next

Head SHA1: 29ad23b00474c34e3b5040dda508c78d33a1a3eb
29ad23b00474c34e3b5040dda508c78d33a1a3eb


Namhyung Kim (4):
      ftrace: Get rid of ftrace_graph_filter_enabled
      ftrace: Introduce struct ftrace_graph_data
      ftrace: Narrow down the protected area of graph_lock
      ftrace: Add set_graph_notrace filter

Steven Rostedt (1):
      tracing: Fix potential out-of-bounds in trace_get_user()

Wang YanQing (1):
      tracing: Show more exact help information about snapshot

----
 include/linux/ftrace.h               |   1 +
 kernel/trace/ftrace.c                | 140 ++++++++++++++++++++++++++---------
 kernel/trace/trace.c                 |   7 +-
 kernel/trace/trace.h                 |  25 ++++++-
 kernel/trace/trace_functions_graph.c |  56 +++++++++++++-
 5 files changed, 186 insertions(+), 43 deletions(-)
