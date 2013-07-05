Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757316Ab3GEKVE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Jul 2013 06:21:04 -0400
Received: from mail-pa0-f45.google.com ([209.85.220.45]:54692 "EHLO
	mail-pa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757287Ab3GEKUN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Jul 2013 06:20:13 -0400
From: Ramkumar Ramachandra <artagnon@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH v2 2/4] perf/Perf-Trace-Util: fix broken include in Context.xs
Date: Fri,  5 Jul 2013 15:46:15 +0530
Message-Id: <1373019377-12741-3-git-send-email-artagnon@gmail.com>
X-Mailer: git-send-email 1.8.3.2.722.g3244e19.dirty
In-Reply-To: <1373019377-12741-1-git-send-email-artagnon@gmail.com>
References: <1373019377-12741-1-git-send-email-artagnon@gmail.com>
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
1.8.3.1.643.gebeea52.dirty

