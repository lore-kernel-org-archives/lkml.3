Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753172AbaAKRtR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Jan 2014 12:49:17 -0500
Received: from smtp4-g21.free.fr ([212.27.42.4]:43904 "EHLO smtp4-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752776AbaAKRtP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Jan 2014 12:49:15 -0500
From: Yann Droneaud <ydroneaud@opteya.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Yann Droneaud <ydroneaud@opteya.com>, linux-kernel@vger.kernel.org,
        Ingo Molnar <mingo@kernel.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        David Ahern <dsahern@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>
Subject: [PATCH 1/2] perf tools: remove unused test-volatile-register-var.c
Date: Sat, 11 Jan 2014 18:48:15 +0100
Message-Id: <339d86ad76741ed929defd18541f774b404003b4.1389461371.git.ydroneaud@opteya.com>
X-Mailer: git-send-email 1.8.4.2
In-Reply-To: <cover.1389461371.git.ydroneaud@opteya.com>
References: <cover.1389461371.git.ydroneaud@opteya.com>
In-Reply-To: <cover.1389461371.git.ydroneaud@opteya.com>
References: <cover.1389461371.git.ydroneaud@opteya.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since commit 01287e2cb7ad, test-volatile-register-var.c
is no more built as part of the automatic feature check.

This patch remove the unneeded file.

Cc: Ingo Molnar <mingo@kernel.org>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: David Ahern <dsahern@gmail.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Signed-off-by: Yann Droneaud <ydroneaud@opteya.com>
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
1.8.4.2

