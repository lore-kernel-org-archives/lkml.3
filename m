Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754202AbaKDNtS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2014 08:49:18 -0500
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.227]:30948 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752676AbaKDNtR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2014 08:49:17 -0500
Message-Id: <20141104134847.978505265@goodmis.org>
User-Agent: quilt/0.61-1
Date: Tue, 04 Nov 2014 08:48:47 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@kernel.org>, Andrew Morton <akpm@linux-foundation.org>
Subject: [for-next][PATCH 0/4] tracing: Some clean ups to the code
X-RR-Connecting-IP: 107.14.168.118:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-trace.git
for-next-next

Head SHA1: bff81446ec9f8331b6443bddb92177fe10e27cb5


Jiang Liu (1):
      tracing: Add entry->next_cpu to trace_ctxwake_bin()

Oleg Nesterov (2):
      tracing: Kill tracing_{start,stop}_sched_switch_record() and tracing_sched_switch_assign_trace()
      tracing: Kill the dead code in probe_sched_switch() and probe_sched_wakeup()

Steven Rostedt (Red Hat) (1):
      tracing: Move tracing_sched_{switch,wakeup}() into wakeup tracer

----
 kernel/trace/trace.h              |  12 ----
 kernel/trace/trace_output.c       |   1 +
 kernel/trace/trace_sched_switch.c | 144 --------------------------------------
 kernel/trace/trace_sched_wakeup.c |  56 +++++++++++++++
 4 files changed, 57 insertions(+), 156 deletions(-)
