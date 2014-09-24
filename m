Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754113AbaIXQ2E (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2014 12:28:04 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.230]:25439 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752194AbaIXQ2A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2014 12:28:00 -0400
Message-Id: <20140924162719.481050866@goodmis.org>
User-Agent: quilt/0.61-1
Date: Wed, 24 Sep 2014 12:27:19 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@kernel.org>, Andrew Morton <akpm@linux-foundation.org>
Subject: [for-next][PATCH 0/3] ftracetest: Added tests for ftrace in the selftests directory
X-RR-Connecting-IP: 107.14.168.118:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-trace.git
for-next

Head SHA1: 7cbfb5eed9832e7c3ae58a17078f62396e7b55f8


Masami Hiramatsu (3):
      ftracetest: Initial commit for ftracetest
      ftracetest: Add ftrace basic testcases
      ftracetest: Add kprobe basic testcases

----
 MAINTAINERS                                        |   1 +
 tools/testing/selftests/Makefile                   |   1 +
 tools/testing/selftests/ftrace/Makefile            |   7 +
 tools/testing/selftests/ftrace/README              |  45 ++++++
 tools/testing/selftests/ftrace/ftracetest          | 159 +++++++++++++++++++++
 .../selftests/ftrace/test.d/00basic/basic1.tc      |   3 +
 .../selftests/ftrace/test.d/00basic/basic2.tc      |   6 +
 .../selftests/ftrace/test.d/00basic/basic3.tc      |   8 ++
 .../ftrace/test.d/kprobe/add_and_remove.tc         |  11 ++
 .../selftests/ftrace/test.d/kprobe/busy_check.tc   |  14 ++
 tools/testing/selftests/ftrace/test.d/template     |   4 +
 11 files changed, 259 insertions(+)
