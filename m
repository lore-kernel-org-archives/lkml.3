Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752628AbaAMUtX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jan 2014 15:49:23 -0500
Received: from merlin.infradead.org ([205.233.59.134]:40472 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752333AbaAMUsN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jan 2014 15:48:13 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Yann Droneaud <ydroneaud@opteya.com>,
        David Ahern <dsahern@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 38/38] perf tools: Remove unused test-volatile-register-var.c
Date: Mon, 13 Jan 2014 17:47:39 -0300
Message-Id: <1389646059-24881-39-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1389646059-24881-1-git-send-email-acme@infradead.org>
References: <1389646059-24881-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by merlin.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Yann Droneaud <ydroneaud@opteya.com>

Since commit 01287e2cb7ad, test-volatile-register-var.c is no more built
as part of the automatic feature check.

This patch remove the unneeded file.

Signed-off-by: Yann Droneaud <ydroneaud@opteya.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/339d86ad76741ed929defd18541f774b404003b4.1389461371.git.ydroneaud@opteya.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/config/feature-checks/test-volatile-register-var.c | 6 ------
 1 file changed, 6 deletions(-)
 delete mode 100644 tools/perf/config/feature-checks/test-volatile-register-var.c

diff --git a/tools/perf/config/feature-checks/test-volatile-register-var.c b/tools/perf/config/feature-checks/test-volatile-register-var.c
deleted file mode 100644
index c9f398d87868..000000000000
--- a/tools/perf/config/feature-checks/test-volatile-register-var.c
+++ /dev/null
@@ -1,6 +0,0 @@
-#include <stdio.h>
-
-int main(void)
-{
-	return puts("hi");
-}
-- 
1.8.1.4

