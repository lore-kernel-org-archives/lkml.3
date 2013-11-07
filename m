Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753386Ab3KGPEr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Nov 2013 10:04:47 -0500
Received: from merlin.infradead.org ([205.233.59.134]:55626 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753084Ab3KGPEk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Nov 2013 10:04:40 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Rodrigo Campos <rodrigo@sdfg.com.ar>,
        Ingo Molnar <mingo@redhat.com>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 7/7] perf tools: Remove unneeded include
Date: Thu,  7 Nov 2013 12:04:18 -0300
Message-Id: <1383836658-10518-8-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1383836658-10518-1-git-send-email-acme@infradead.org>
References: <1383836658-10518-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by merlin.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rodrigo Campos <rodrigo@sdfg.com.ar>

There is no point in sort.h including itself.

The include was added when the file was created, in commit "perf tools:
Create util/sort.and use it" (dd68ada2d) and added a include to "sort.h"
in lot of files (all the files that started using the file). It was
probably added by mistake on sort.h too.

Signed-off-by: Rodrigo Campos <rodrigo@sdfg.com.ar>
Acked-by: Namhyung Kim <namhyung@kernel.org>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/1383776454-10595-1-git-send-email-rodrigo@sdfg.com.ar
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/sort.h | 1 -
 1 file changed, 1 deletion(-)

diff --git a/tools/perf/util/sort.h b/tools/perf/util/sort.h
index f4cc147e0220..43e5ff42a609 100644
--- a/tools/perf/util/sort.h
+++ b/tools/perf/util/sort.h
@@ -22,7 +22,6 @@
 #include "parse-events.h"
 
 #include "thread.h"
-#include "sort.h"
 
 extern regex_t parent_regex;
 extern const char *sort_order;
-- 
1.8.1.4

