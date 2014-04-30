Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964831AbaD3Mme (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2014 08:42:34 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.231]:42203 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1758763AbaD3Mmc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2014 08:42:32 -0400
Message-Id: <20140430124153.334527053@goodmis.org>
User-Agent: quilt/0.61-1
Date: Wed, 30 Apr 2014 08:41:53 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@kernel.org>, Frederic Weisbecker <fweisbec@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [for-next][PATCH 0/4] tracing: Updates for 3.16
X-RR-Connecting-IP: 107.14.168.130:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-trace.git
for-next

Head SHA1: b1169cc69ba96b124df820904a6d3eb775491d7f


Jiaxing Wang (2):
      tracing/stack_trace: Skip 4 instead of 3 when using ftrace_ops_list_func
      tracing: Fix documentation of ftrace_set_global_{filter,notrace}()

Steven Rostedt (Red Hat) (2):
      tracing: Break out of tracing_wait_pipe() before wait_pipe() is called
      tracing: Remove mock up poll wait function

----
 kernel/trace/ftrace.c                | 11 +++++----
 kernel/trace/trace.c                 | 45 ++++++++++--------------------------
 kernel/trace/trace.h                 |  5 +---
 kernel/trace/trace_functions.c       |  1 -
 kernel/trace/trace_functions_graph.c |  1 -
 kernel/trace/trace_nop.c             |  1 -
 kernel/trace/trace_sched_wakeup.c    |  2 --
 kernel/trace/trace_stack.c           |  8 +++++--
 8 files changed, 26 insertions(+), 48 deletions(-)
