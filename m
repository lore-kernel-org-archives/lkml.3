Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934926AbaEaBja (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 May 2014 21:39:30 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.229]:54987 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S932323AbaEaBj1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 May 2014 21:39:27 -0400
Message-Id: <20140531013857.160310242@goodmis.org>
User-Agent: quilt/0.63-1
Date: Fri, 30 May 2014 21:38:57 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@kernel.org>, Andrew Morton <akpm@linux-foundation.org>
Subject: [for-next][PATCH 0/7] tracing: More changes queued up for 3.16
X-RR-Connecting-IP: 107.14.168.130:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-trace.git
for-next

Head SHA1: 676412a37f248205ecadfaddb50e150a44ef2b0c


Robert Elliott (2)
      tracing: Eliminate duplicate TRACE_GRAPH_PRINT_xx defines
      tracing: Add funcgraph_tail option to print function name after closing braces

Steven Rostedt (1)
      tracing: Print nasty banner when trace_printk() is in use

Steven Rostedt (Red Hat) (3)
      tracing: Add tracepoint benchmark tracepoint
      tracing: Try again for saved cmdline if failed due to locking
      tracing: Move locking of trace_cmdline_lock into start/stop seq calls

Yoshihiro YUNOMAE (1)
      tracing: Have saved_cmdlines use the seq_read infrastructure

----
 Documentation/trace/ftrace.txt       |   26 +++++
 kernel/trace/Kconfig                 |   30 +++++
 kernel/trace/Makefile                |    3 
 kernel/trace/trace.c                 |  137 ++++++++++++++++++---------
 kernel/trace/trace.h                 |    2 
 kernel/trace/trace_benchmark.c       |  176 +++++++++++++++++++++++++++++++++++
 kernel/trace/trace_benchmark.h       |   41 ++++++++
 kernel/trace/trace_functions_graph.c |   18 +--
 8 files changed, 375 insertions(+), 58 deletions(-)
