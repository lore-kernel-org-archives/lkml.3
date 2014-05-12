Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758835AbaELPMK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 May 2014 11:12:10 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.227]:21047 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1758444AbaELPMF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 May 2014 11:12:05 -0400
Message-Id: <20140512151202.978272874@goodmis.org>
User-Agent: quilt/0.61-1
Date: Mon, 12 May 2014 11:11:32 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@kernel.org>, Frederic Weisbecker <fweisbec@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Jiri Olsa <jolsa@redhat.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Namhyung Kim <namhyung@kernel.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: [for-next][PATCH 02/13] tracing: Remove myself as a tracing maintainer
References: <20140512151130.345864843@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline; filename=0002-tracing-Remove-myself-as-a-tracing-maintainer.patch
X-RR-Connecting-IP: 107.14.168.142:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Frederic Weisbecker <fweisbec@gmail.com>

It has been a while since I last sent a tracing patch. I always keep an
eye on tracing evolutions and contributions in general but given
how busy I am with nohz, isolation and more generally core cleanups stuff,
I seldom have time left to provide deep reviews of tracing patches nor
simply for reviews to begin with.

I've been very lucky to start kernel development on a very young subsystem
with tons of low hanging fruits back in 2008. Given that it deals with
a lot of tricky stuffs all around (sched, timers, irq, preemption, NMIs,
SMP, RCU, ....) I basically learned everything there.

Steve has been doing most of the incredible work these last years.
Thanks a lot!

Of course consider me always available to help on tracing if any hard
days happen.

Link: http://lkml.kernel.org/p/1399131991-13216-1-git-send-email-fweisbec@gmail.com

Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 MAINTAINERS | 1 -
 1 file changed, 1 deletion(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index e67ea24..120af71 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -9041,7 +9041,6 @@ F:	drivers/char/tpm/
 
 TRACING
 M:	Steven Rostedt <rostedt@goodmis.org>
-M:	Frederic Weisbecker <fweisbec@gmail.com>
 M:	Ingo Molnar <mingo@redhat.com>
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git perf/core
 S:	Maintained
-- 
1.8.5.3


