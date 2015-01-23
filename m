Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756640AbbAWVv3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jan 2015 16:51:29 -0500
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.228]:54315 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1756559AbbAWVv1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jan 2015 16:51:27 -0500
Message-Id: <20150123215010.626661716@goodmis.org>
User-Agent: quilt/0.61-1
Date: Fri, 23 Jan 2015 16:50:10 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@kernel.org>, Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 0/2] tracing: Some clean ups that will help tracefs
X-RR-Connecting-IP: 107.14.168.118:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I added these two patches before applying my tracefs changes.
I'm still waiting on review from Al or Greg from tracefs, but these
fixes are just some clean ups that are unrelated. But should go into
linux-next now anyway.

  git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-trace.git
for-next

Head SHA1: 14a5ae40f0def33a422a45b2ed09198adb7bf11c


Steven Rostedt (Red Hat) (2):
      tracing: Remove unneeded includes of debugfs.h and fs.h
      tracing: Use IS_ERR() check for return value of tracing_init_dentry()

----
 kernel/trace/ftrace.c                | 2 +-
 kernel/trace/ring_buffer.c           | 2 --
 kernel/trace/trace.c                 | 8 ++++----
 kernel/trace/trace_branch.c          | 1 -
 kernel/trace/trace_events.c          | 2 +-
 kernel/trace/trace_export.c          | 2 --
 kernel/trace/trace_functions_graph.c | 2 +-
 kernel/trace/trace_irqsoff.c         | 2 --
 kernel/trace/trace_kprobe.c          | 2 +-
 kernel/trace/trace_nop.c             | 2 --
 kernel/trace/trace_printk.c          | 4 +---
 kernel/trace/trace_sched_switch.c    | 2 --
 kernel/trace/trace_sched_wakeup.c    | 2 --
 kernel/trace/trace_stack.c           | 4 +---
 kernel/trace/trace_stat.c            | 2 +-
 kernel/trace/trace_uprobe.c          | 2 +-
 16 files changed, 12 insertions(+), 29 deletions(-)
