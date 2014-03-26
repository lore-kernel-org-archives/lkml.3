Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756227AbaCZUy6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Mar 2014 16:54:58 -0400
Received: from mail-qg0-f43.google.com ([209.85.192.43]:47496 "EHLO
	mail-qg0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754664AbaCZUyz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Mar 2014 16:54:55 -0400
From: Ramkumar Ramachandra <artagnon@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Steven Rostedt <rostedt@goodmis.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH v2] MAINTAINERS: add tools/lib/traceevent/ to perf subsystem
Date: Wed, 26 Mar 2014 16:55:57 -0400
Message-Id: <1395867357-20737-1-git-send-email-artagnon@gmail.com>
X-Mailer: git-send-email 1.9.0.431.g014438b
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

While at it, add Steven Rostedt to the list of maintainers.

Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Ramkumar Ramachandra <artagnon@gmail.com>
---
 MAINTAINERS | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index 82640e6..3e8b402 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -6682,6 +6682,7 @@ M:	Peter Zijlstra <a.p.zijlstra@chello.nl>
 M:	Paul Mackerras <paulus@samba.org>
 M:	Ingo Molnar <mingo@redhat.com>
 M:	Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
+M:	Steven Rostedt <rostedt@goodmis.org>
 L:	linux-kernel@vger.kernel.org
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git perf/core
 S:	Supported
@@ -6694,6 +6695,7 @@ F:	arch/*/kernel/*/*/perf_event*.c
 F:	arch/*/include/asm/perf_event.h
 F:	arch/*/kernel/perf_callchain.c
 F:	tools/perf/
+F:	tools/lib/traceevent/
 
 PERSONALITY HANDLING
 M:	Christoph Hellwig <hch@infradead.org>
-- 
1.9.0.431.g014438b

