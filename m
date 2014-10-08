Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753686AbaJHSFY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Oct 2014 14:05:24 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.227]:57050 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751257AbaJHSFT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Oct 2014 14:05:19 -0400
Message-Id: <20141008180341.252728944@goodmis.org>
User-Agent: quilt/0.61-1
Date: Wed, 08 Oct 2014 14:03:41 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 0/5] [GIT PULL] ftracetest/tools/selftests: Self tests to test ftrace
X-RR-Connecting-IP: 107.14.168.142:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Linus,

This patch series starts a new selftests section in the
tools/testing/selftest directory called "ftrace" that holds tests
aimed at testing ftrace and subsystems that use ftrace (like kprobes).

So far only a few tests were written (by Masami Hiramatsu), but more will
be added in the near future (3.19).

Please pull the latest ftracetest-3.18 tree, which can be found at:


  git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-trace.git
ftracetest-3.18

Tag SHA1: 82533f8d106661960f4675f5f3248c00e9157f49
Head SHA1: 89c5497d1f933af56dac617f0fd86150942a7fb6


Masami Hiramatsu (5):
      ftracetest: Initial commit for ftracetest
      ftracetest: Add ftrace basic testcases
      ftracetest: Add kprobe basic testcases
      ftracetest: Add POSIX.3 standard and XFAIL result codes
      tracing/kprobes: Add selftest scripts testing kprobe-tracer as startup test

----
 MAINTAINERS                                        |   1 +
 tools/testing/selftests/Makefile                   |   1 +
 tools/testing/selftests/ftrace/Makefile            |   7 +
 tools/testing/selftests/ftrace/README              |  82 +++++++
 tools/testing/selftests/ftrace/ftracetest          | 253 +++++++++++++++++++++
 tools/testing/selftests/ftrace/samples/fail.tc     |   4 +
 tools/testing/selftests/ftrace/samples/pass.tc     |   3 +
 .../testing/selftests/ftrace/samples/unresolved.tc |   4 +
 .../selftests/ftrace/samples/unsupported.tc        |   3 +
 tools/testing/selftests/ftrace/samples/untested.tc |   3 +
 tools/testing/selftests/ftrace/samples/xfail.tc    |   3 +
 .../selftests/ftrace/test.d/00basic/basic1.tc      |   3 +
 .../selftests/ftrace/test.d/00basic/basic2.tc      |   7 +
 .../selftests/ftrace/test.d/00basic/basic3.tc      |   8 +
 .../ftrace/test.d/kprobe/add_and_remove.tc         |  11 +
 .../selftests/ftrace/test.d/kprobe/busy_check.tc   |  13 ++
 .../selftests/ftrace/test.d/kprobe/kprobe_args.tc  |  16 ++
 .../ftrace/test.d/kprobe/kretprobe_args.tc         |  15 ++
 tools/testing/selftests/ftrace/test.d/template     |   9 +
 19 files changed, 446 insertions(+)
