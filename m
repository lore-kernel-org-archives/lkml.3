Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753515AbaCQW20 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Mar 2014 18:28:26 -0400
Received: from mail-yk0-f177.google.com ([209.85.160.177]:39214 "EHLO
	mail-yk0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753356AbaCQWZ4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Mar 2014 18:25:56 -0400
From: Ramkumar Ramachandra <artagnon@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Steven Rostedt <rostedt@goodmis.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 1/5] MAINTAINERS: add tools/lib/traceevent/ to perf subsystem
Date: Mon, 17 Mar 2014 18:26:34 -0400
Message-Id: <1395095198-20034-2-git-send-email-artagnon@gmail.com>
X-Mailer: git-send-email 1.9.0.431.g014438b
In-Reply-To: <1395095198-20034-1-git-send-email-artagnon@gmail.com>
References: <1395095198-20034-1-git-send-email-artagnon@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Ramkumar Ramachandra <artagnon@gmail.com>
---
 MAINTAINERS | 1 +
 1 file changed, 1 insertion(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index b3fdb0f..788effd 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -6693,6 +6693,7 @@ F:	arch/*/kernel/*/*/perf_event*.c
 F:	arch/*/include/asm/perf_event.h
 F:	arch/*/kernel/perf_callchain.c
 F:	tools/perf/
+F:	tools/lib/traceevent/
 
 PERSONALITY HANDLING
 M:	Christoph Hellwig <hch@infradead.org>
-- 
1.9.0.431.g014438b

