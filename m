Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757758Ab3GLIxG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jul 2013 04:53:06 -0400
Received: from terminus.zytor.com ([198.137.202.10]:54924 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757724Ab3GLIxE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jul 2013 04:53:04 -0400
Date: Fri, 12 Jul 2013 01:52:52 -0700
From: tip-bot for Ramkumar Ramachandra <tipbot@zytor.com>
Message-ID: <tip-750ade7e82709c2835cb221a7b6a9ef0a6a9c0ac@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, hpa@zytor.com,
        mingo@kernel.org, artagnon@gmail.com, tglx@linutronix.de,
        namhyung@kernel.org
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        acme@redhat.com, tglx@linutronix.de, artagnon@gmail.com,
        namhyung@kernel.org
In-Reply-To: <1373364033-7918-3-git-send-email-artagnon@gmail.com>
References: <1373364033-7918-3-git-send-email-artagnon@gmail.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] perf script: Fix broken include in Context.xs
Git-Commit-ID: 750ade7e82709c2835cb221a7b6a9ef0a6a9c0ac
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Fri, 12 Jul 2013 01:52:58 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  750ade7e82709c2835cb221a7b6a9ef0a6a9c0ac
Gitweb:     http://git.kernel.org/tip/750ade7e82709c2835cb221a7b6a9ef0a6a9c0ac
Author:     Ramkumar Ramachandra <artagnon@gmail.com>
AuthorDate: Tue, 9 Jul 2013 15:30:30 +0530
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Wed, 10 Jul 2013 13:47:00 -0300

perf script: Fix broken include in Context.xs

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
