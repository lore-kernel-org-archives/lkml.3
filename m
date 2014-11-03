Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754134AbaKCV2q (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2014 16:28:46 -0500
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.232]:62037 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753482AbaKCV2o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2014 16:28:44 -0500
Message-Id: <20141103212737.696365174@goodmis.org>
User-Agent: quilt/0.61-1
Date: Mon, 03 Nov 2014 16:27:37 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [RFC PATCH 0/4 v2] ftracetests: Add ftrace tests to ftracetests
X-RR-Connecting-IP: 107.14.168.142:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Second attempt. I took the advice from Masami Hiramatsu and modified
my tests. I also added some helper functions to ftracetests as well.

I split the one function graph test into two. One to just test the
filtering of the function graph and another to test with stack tracer.

Steven Rostedt (Red Hat) (4):
      ftracetest: Add clear_trace() helper to reset the trace file
      ftracetest: Add disable/enable_tracing() helper calls
      ftracetest: Add helper reset_tracer() function
      ftracetest: Add a couple of ftrace test cases

----
 tools/testing/selftests/ftrace/ftracetest          |  3 +
 .../ftrace/test.d/ftrace/fgraph-filter-stack.tc    | 94 ++++++++++++++++++++++
 .../ftrace/test.d/ftrace/fgraph-filter.tc          | 49 +++++++++++
 .../ftrace/test.d/ftrace/func_profiler.tc          | 76 +++++++++++++++++
 tools/testing/selftests/ftrace/test.d/functions    | 16 ++++
 5 files changed, 238 insertions(+)

