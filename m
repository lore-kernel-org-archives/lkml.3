Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754460AbaKDPas (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2014 10:30:48 -0500
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.228]:62276 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753808AbaKDPan (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2014 10:30:43 -0500
Message-Id: <20141104152845.521858531@goodmis.org>
User-Agent: quilt/0.61-1
Date: Tue, 04 Nov 2014 10:28:45 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Namhyung Kim <namhyung@kernel.org>
Subject: [PATCH 0/2 v3] ftracetest: Add ftrace tests to ftracetests
X-RR-Connecting-IP: 107.14.168.118:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Third attempt. Moved helper functions into a single patch. Removed the
extra check of schedule in the trace file.

Not an RFC this time. I'm hoping this is "good enough" ;-)

Steven Rostedt (Red Hat) (2):
      ftracetest: Add functions file that holds helper functions
      ftracetest: Add a couple of ftrace test cases

----
 tools/testing/selftests/ftrace/ftracetest          |  3 +
 .../ftrace/test.d/ftrace/fgraph-filter-stack.tc    | 88 ++++++++++++++++++++++
 .../ftrace/test.d/ftrace/fgraph-filter.tc          | 49 ++++++++++++
 .../ftrace/test.d/ftrace/func_profiler.tc          | 76 +++++++++++++++++++
 tools/testing/selftests/ftrace/test.d/functions    | 16 ++++
 5 files changed, 232 insertions(+)
