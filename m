Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752614AbaFEPVT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2014 11:21:19 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.228]:63203 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752471AbaFEPVS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2014 11:21:18 -0400
Message-Id: <20140605152114.191155594@goodmis.org>
User-Agent: quilt/0.63-1
Date: Thu, 05 Jun 2014 11:15:44 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>
Subject: [for-next][PATCH 4/5] tracing: Remove unused variable in trace_benchmark
References: <20140605151540.672365024@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline; filename=0003-tracing-Remove-unused-variable-in-trace_benchmark.patch
X-RR-Connecting-IP: 107.14.168.142:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Steven Rostedt (Red Hat)" <rostedt@goodmis.org>

Somehow this unused variable warning sneaked past my warnings check
(probably due to it depending on a new config).

kernel/trace/trace_benchmark.c: In function 'trace_do_benchmark':
kernel/trace/trace_benchmark.c:38:6: warning: unused variable 'seedsq' [-Wunused-variable]
  u64 seedsq;
      ^

Link: http://lkml.kernel.org/r/20140604160921.4f4e69c4@canb.auug.org.au

Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/trace_benchmark.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/kernel/trace/trace_benchmark.c b/kernel/trace/trace_benchmark.c
index 7dc1c42dfee2..a10adc7095cd 100644
--- a/kernel/trace/trace_benchmark.c
+++ b/kernel/trace/trace_benchmark.c
@@ -35,7 +35,6 @@ static void trace_do_benchmark(void)
 	u64 delta;
 	s64 stddev;
 	u64 seed;
-	u64 seedsq;
 	u64 last_seed;
 	unsigned int avg;
 	unsigned int std = 0;
-- 
2.0.0.rc2


