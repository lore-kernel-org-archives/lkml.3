Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752429AbaECPqi (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 May 2014 11:46:38 -0400
Received: from mail-wi0-f181.google.com ([209.85.212.181]:42516 "EHLO
	mail-wi0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750979AbaECPqh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 May 2014 11:46:37 -0400
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Ingo Molnar <mingo@kernel.org>, Jiri Olsa <jolsa@redhat.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Namhyung Kim <namhyung@kernel.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH] tracing: Remove myself as a tracing maintainer
Date: Sat,  3 May 2014 17:46:31 +0200
Message-Id: <1399131991-13216-1-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.8.3.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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

Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
---
 MAINTAINERS | 1 -
 1 file changed, 1 deletion(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 6dc67b1..b69be85 100644
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
1.8.3.1

