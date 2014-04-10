Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030760AbaDJNBD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Apr 2014 09:01:03 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.228]:41131 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1030544AbaDJNBB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Apr 2014 09:01:01 -0400
Message-Id: <20140410130021.634516192@goodmis.org>
User-Agent: quilt/0.61-1
Date: Thu, 10 Apr 2014 09:00:21 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@kernel.org>, Frederic Weisbecker <fweisbec@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Subject: [for-next][PATCH 0/2] tracing: Fix for sparse warnings and anonymous unions
X-RR-Connecting-IP: 107.14.168.142:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-trace.git
for-next

Head SHA1: abb43f6998eb6466ea392d3757e673bbdb6ae171


Mathieu Desnoyers (2):
      tracepoint: Fix sparse warnings in tracepoint.c
      tracing: Fix anonymous unions in struct ftrace_event_call

----
 include/linux/syscalls.h        |  8 ++++++--
 include/linux/tracepoint.h      |  5 +++++
 include/trace/events/syscalls.h |  3 ---
 include/trace/ftrace.h          | 12 +++++++++---
 kernel/trace/trace_export.c     |  6 ++++--
 kernel/tracepoint.c             |  6 ++++--
 6 files changed, 28 insertions(+), 12 deletions(-)
