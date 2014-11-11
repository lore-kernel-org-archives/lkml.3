Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752337AbaKKVmJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2014 16:42:09 -0500
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.230]:55229 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751982AbaKKVmH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2014 16:42:07 -0500
Message-Id: <20141111214127.196849367@goodmis.org>
User-Agent: quilt/0.61-1
Date: Tue, 11 Nov 2014 16:41:27 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 0/6] ftracetest: Updates for 3.19
X-RR-Connecting-IP: 107.14.168.142:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-trace.git
for-next

Head SHA1: 815b18ea66d6fb67a3534edf68dfa23bdcec0485


Heiko Carstens (1):
      ftracetest: Sort testcases

Namhyung Kim (3):
      ftracetest: Use logfile name supported by busybox's mktemp
      ftracetest: Clear trace buffer after running kprobe testcases
      ftracetest: Add basic event tracing test cases

Steven Rostedt (Red Hat) (2):
      ftracetest: Add functions file that holds helper functions
      ftracetest: Add a couple of ftrace test cases

----
 tools/testing/selftests/ftrace/ftracetest          |  7 +-
 .../selftests/ftrace/test.d/00basic/basic4.tc      |  5 ++
 .../selftests/ftrace/test.d/event/event-enable.tc  | 53 +++++++++++++
 .../ftrace/test.d/event/subsystem-enable.tc        | 53 +++++++++++++
 .../ftrace/test.d/event/toplevel-enable.tc         | 47 ++++++++++++
 .../ftrace/test.d/ftrace/fgraph-filter-stack.tc    | 89 ++++++++++++++++++++++
 .../ftrace/test.d/ftrace/fgraph-filter.tc          | 52 +++++++++++++
 .../ftrace/test.d/ftrace/func_profiler.tc          | 80 +++++++++++++++++++
 tools/testing/selftests/ftrace/test.d/functions    | 16 ++++
 .../ftrace/test.d/kprobe/add_and_remove.tc         |  1 +
 .../selftests/ftrace/test.d/kprobe/busy_check.tc   |  1 +
 .../selftests/ftrace/test.d/kprobe/kprobe_args.tc  |  1 +
 .../ftrace/test.d/kprobe/kretprobe_args.tc         |  1 +
 13 files changed, 404 insertions(+), 2 deletions(-)
