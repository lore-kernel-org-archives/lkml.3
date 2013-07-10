Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754964Ab3GJTUE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Jul 2013 15:20:04 -0400
Received: from merlin.infradead.org ([205.233.59.134]:56846 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754774Ab3GJTT4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Jul 2013 15:19:56 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Ramkumar Ramachandra <artagnon@gmail.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 23/23] perf script: Fix broken include in Context.xs
Date: Wed, 10 Jul 2013 16:19:23 -0300
Message-Id: <1373483963-19277-24-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1373483963-19277-1-git-send-email-acme@infradead.org>
References: <1373483963-19277-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by merlin.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ramkumar Ramachandra <artagnon@gmail.com>

765532c8 (perf script: Finish the rename from trace to script,
2010-12-23) made a mistake during find-and-replace replacing
"../../../util/trace-event.h" with "../../../util/script-event.h", a
non-existent file.  Fix this include.

Signed-off-by: Ramkumar Ramachandra <artagnon@gmail.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Link: http://lkml.kernel.org/r/1373364033-7918-3-git-send-email-artagnon@gmail.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/scripts/perl/Perf-Trace-Util/Context.xs | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/perf/scripts/perl/Perf-Trace-Util/Context.xs b/tools/perf/scripts/perl/Perf-Trace-Util/Context.xs
index c1e2ed1..8c7ea42 100644
--- a/tools/perf/scripts/perl/Perf-Trace-Util/Context.xs
+++ b/tools/perf/scripts/perl/Perf-Trace-Util/Context.xs
@@ -23,7 +23,7 @@
 #include "perl.h"
 #include "XSUB.h"
 #include "../../../perf.h"
-#include "../../../util/script-event.h"
+#include "../../../util/trace-event.h"
 
 MODULE = Perf::Trace::Context		PACKAGE = Perf::Trace::Context
 PROTOTYPES: ENABLE
-- 
1.8.1.4

