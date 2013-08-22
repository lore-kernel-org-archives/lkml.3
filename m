Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753390Ab3HVQeX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Aug 2013 12:34:23 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:24138 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753025Ab3HVQeV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Aug 2013 12:34:21 -0400
X-Authority-Analysis: v=2.0 cv=e9yEuNV/ c=1 sm=0 a=Sro2XwOs0tJUSHxCKfOySw==:17 a=Drc5e87SC40A:10 a=Ciwy3NGCPMMA:10 a=tsrkiDjWosUA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=IOU7S4-zajMA:10 a=VwQbUJbxAAAA:8 a=QR0adpbhaoGLAujRpmkA:9 a=Sro2XwOs0tJUSHxCKfOySw==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.255.60.225
Message-Id: <20130822163225.773134216@goodmis.org>
User-Agent: quilt/0.60-1
Date: Thu, 22 Aug 2013 12:32:25 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@kernel.org>, Frederic Weisbecker <fweisbec@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [for-next][PATCH 0/5] tracing: few updates
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I final have time to start looking at my INBOX. There's several patches
that need to be pushed for 3.12. They are mostly clean ups and not anything
urgent.

I'm still in the process of going through my INBOX (backwards in time)
so I may find new stuff as well.

-- Steve

  git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-trace.git
for-next

Head SHA1: fc30f13b7c1b87b44ee364462c3408c913f01439


Li Zefan (1)
      tracing/syscalls: Annotate raw_init function with __init

Oleg Nesterov (3)
      tracing: Kill trace_create_file_ops() and friends
      tracing: Don't pass file_operations array to event_create_dir()
      tracing: Kill the !CONFIG_MODULES code in trace_events.c

Steven Rostedt (Red Hat) (1)
      tracing: Add __tracepoint_string() to export string pointers

----
 b/include/asm-generic/vmlinux.lds.h |    7 +
 b/include/linux/ftrace_event.h      |   34 ++++++++
 b/kernel/trace/trace.h              |    3 
 b/kernel/trace/trace_events.c       |  153 ++----------------------------------
 b/kernel/trace/trace_printk.c       |   19 ++++
 b/kernel/trace/trace_syscalls.c     |   10 +-
 kernel/trace/trace_events.c         |   64 ++++-----------
 7 files changed, 94 insertions(+), 196 deletions(-)
