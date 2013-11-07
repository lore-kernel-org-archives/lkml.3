Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753171Ab3KGEAw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Nov 2013 23:00:52 -0500
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.225]:38742 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752773Ab3KGEAv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Nov 2013 23:00:51 -0500
Message-Id: <20131107040002.605895766@goodmis.org>
User-Agent: quilt/0.60-1
Date: Wed, 06 Nov 2013 23:00:02 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@kernel.org>, Frederic Weisbecker <fweisbec@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [for-next][PATCH 0/5] tracing: More updates for 3.13
X-RR-Connecting-IP: 107.14.168.130:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-trace.git
for-next

Head SHA1: 20b72e76c42bc4f0dd091f9faee542ea45ad6b5e


Cody P Schafer (1):
      tracing: Open tracer when ftrace_dump_on_oops is used

Geyslan G. Bem (2):
      tracing: Add helper function tracing_is_disabled()
      tracing: Do not assign filp->private_data to freed memory

Steven Rostedt (1):
      Merge branch 'trace/ftrace/core' into trace/for-next

Steven Rostedt (Red Hat) (2):
      tracing: Remove unused function ftrace_off_permanent()
      tracing: Do not use signed enums with unsigned long long in fgragh output

----
 include/linux/kernel.h               |  2 --
 kernel/trace/trace.c                 | 31 ++++++++++++++++---------------
 kernel/trace/trace.h                 |  3 +++
 kernel/trace/trace_events.c          |  9 ++++++++-
 kernel/trace/trace_functions_graph.c | 22 +++++++++++-----------
 5 files changed, 38 insertions(+), 29 deletions(-)
