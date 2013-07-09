Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753808Ab3GIKFW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Jul 2013 06:05:22 -0400
Received: from mail-pa0-f52.google.com ([209.85.220.52]:62491 "EHLO
	mail-pa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753538Ab3GIKE0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Jul 2013 06:04:26 -0400
From: Ramkumar Ramachandra <artagnon@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Namhyung Kim <namhyung@kernel.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH v3 2/5] perf/Perf-Trace-Util: fix broken include in Context.xs
Date: Tue,  9 Jul 2013 15:30:30 +0530
Message-Id: <1373364033-7918-3-git-send-email-artagnon@gmail.com>
X-Mailer: git-send-email 1.8.3.2.736.g869de25
In-Reply-To: <1373364033-7918-1-git-send-email-artagnon@gmail.com>
References: <1373364033-7918-1-git-send-email-artagnon@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

765532c8 (perf script: Finish the rename from trace to script,
2010-12-23) made a mistake during find-and-replace replacing
"../../../util/trace-event.h" with "../../../util/script-event.h", a
non-existent file.  Fix this include.

Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Ramkumar Ramachandra <artagnon@gmail.com>
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
1.8.3.2.736.g869de25

