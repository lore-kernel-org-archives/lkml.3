Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754685Ab3KGPc1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Nov 2013 10:32:27 -0500
Received: from terminus.zytor.com ([198.137.202.10]:40835 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754599Ab3KGPcY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Nov 2013 10:32:24 -0500
Date: Thu, 7 Nov 2013 07:31:21 -0800
From: tip-bot for Rodrigo Campos <tipbot@zytor.com>
Message-ID: <tip-8ce000e83848578a621d64eccdc88bd34c2fc70c@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, paulus@samba.org,
        mingo@redhat.com, hpa@zytor.com, mingo@kernel.org,
        a.p.zijlstra@chello.nl, rodrigo@sdfg.com.ar, namhyung@kernel.org,
        tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, mingo@redhat.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, acme@redhat.com, a.p.zijlstra@chello.nl,
        rodrigo@sdfg.com.ar, namhyung@kernel.org, tglx@linutronix.de
In-Reply-To: <1383776454-10595-1-git-send-email-rodrigo@sdfg.com.ar>
References: <1383776454-10595-1-git-send-email-rodrigo@sdfg.com.ar>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf tools: Remove unneeded include
Git-Commit-ID: 8ce000e83848578a621d64eccdc88bd34c2fc70c
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Thu, 07 Nov 2013 07:31:27 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  8ce000e83848578a621d64eccdc88bd34c2fc70c
Gitweb:     http://git.kernel.org/tip/8ce000e83848578a621d64eccdc88bd34c2fc70c
Author:     Rodrigo Campos <rodrigo@sdfg.com.ar>
AuthorDate: Wed, 6 Nov 2013 22:20:54 +0000
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Thu, 7 Nov 2013 11:51:19 -0300

perf tools: Remove unneeded include

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
index f4cc147..43e5ff4 100644
--- a/tools/perf/util/sort.h
+++ b/tools/perf/util/sort.h
@@ -22,7 +22,6 @@
 #include "parse-events.h"
 
 #include "thread.h"
-#include "sort.h"
 
 extern regex_t parent_regex;
 extern const char *sort_order;
