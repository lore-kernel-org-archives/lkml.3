Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753281AbaKYMO2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2014 07:14:28 -0500
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.225]:12389 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751019AbaKYMO1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2014 07:14:27 -0500
Message-Id: <20141125121355.225538266@goodmis.org>
User-Agent: quilt/0.61-1
Date: Tue, 25 Nov 2014 07:13:55 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@kernel.org>, Andrew Morton <akpm@linux-foundation.org>
Subject: [for-next][PATCH 0/5] ftrace: More stuff for 3.19
X-RR-Connecting-IP: 107.14.168.142:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-trace.git
for-next

Head SHA1: 62a207d748dd9224140a634786b274fdb6ece0b9


Masami Hiramatsu (3):
      kprobes/ftrace: Recover original IP if pre_handler doesn't change it
      ftrace, kprobes: Support IPMODIFY flag to find IP modify conflict
      kprobes: Add IPMODIFY flag to kprobe_ftrace_ops

Steven Rostedt (Red Hat) (2):
      tracing/trivial: Fix typos and make an int into a bool
      ftrace/x86: Have static function tracing always test for function graph

----
 Documentation/trace/ftrace.txt   |   5 ++
 arch/x86/kernel/kprobes/ftrace.c |   9 ++-
 arch/x86/kernel/mcount_64.S      |   3 +-
 include/linux/ftrace.h           |  16 ++++-
 kernel/kprobes.c                 |   2 +-
 kernel/trace/ftrace.c            | 144 ++++++++++++++++++++++++++++++++++++++-
 kernel/trace/trace_functions.c   |   6 +-
 7 files changed, 172 insertions(+), 13 deletions(-)
