Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757535AbaAJPVG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jan 2014 10:21:06 -0500
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.225]:43189 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751841AbaAJPVD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jan 2014 10:21:03 -0500
Message-Id: <20140110152004.200225053@goodmis.org>
User-Agent: quilt/0.60-1
Date: Fri, 10 Jan 2014 10:20:04 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@kernel.org>, Frederic Weisbecker <fweisbec@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [for-next][PATCH 0/5] tracing: event trigger updates
X-RR-Connecting-IP: 107.14.168.142:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-trace.git
for-next

Head SHA1: dd97b95438c812d8fd93d9426661a6c8e1520005


Steven Rostedt (Red Hat) (3):
      tracing: Fix counter for traceon/off event triggers
      tracing: Consolidate event trigger code
      tracing: Show available event triggers when no trigger is set

Tom Zanussi (2):
      tracing/kprobes: Add trace event trigger invocations
      tracing: Remove double-underscore naming in syscall trigger invocations

----
 include/linux/ftrace_event.h        | 117 ++++++++++++++++++++++++++++++++++++
 include/trace/ftrace.h              |  23 ++-----
 kernel/trace/trace_events_trigger.c |  30 ++++++++-
 kernel/trace/trace_kprobe.c         |  14 ++---
 kernel/trace/trace_syscalls.c       |  48 +++------------
 5 files changed, 163 insertions(+), 69 deletions(-)
