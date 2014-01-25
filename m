Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752553AbaAYVuk (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Jan 2014 16:50:40 -0500
Received: from guitar.tcltek.co.il ([192.115.133.116]:38796 "EHLO
	mx.tkos.co.il" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752103AbaAYVuj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Jan 2014 16:50:39 -0500
From: Baruch Siach <baruch@tkos.co.il>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: linux-kernel@vger.kernel.org, Baruch Siach <baruch@tkos.co.il>
Subject: [PATCH RESEND] perf: design.txt: remove mention of set_perf_event_pending
Date: Sat, 25 Jan 2014 23:50:23 +0200
Message-Id: <4c54761865d40210be0628cb84701afc5d57b5d8.1390686193.git.baruch@tkos.co.il>
X-Mailer: git-send-email 1.8.5.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

set_perf_event_pending() was removed in e360adbe (irq_work: Add generic hardirq
context callbacks)

Signed-off-by: Baruch Siach <baruch@tkos.co.il>
---
Resending with lkml added to Cc.
---
 tools/perf/design.txt | 1 -
 1 file changed, 1 deletion(-)

diff --git a/tools/perf/design.txt b/tools/perf/design.txt
index 67e5d0cace85..63a0e6f04a01 100644
--- a/tools/perf/design.txt
+++ b/tools/perf/design.txt
@@ -454,7 +454,6 @@ So to start with, in order to add HAVE_PERF_EVENTS to your Kconfig, you
 will need at least this:
 	- asm/perf_event.h - a basic stub will suffice at first
 	- support for atomic64 types (and associated helper functions)
-	- set_perf_event_pending() implemented
 
 If your architecture does have hardware capabilities, you can override the
 weak stub hw_perf_event_init() to register hardware counters.
-- 
1.8.5.2

