Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932089Ab3DEB0o (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Apr 2013 21:26:44 -0400
Received: from LGEMRELSE1Q.lge.com ([156.147.1.111]:50216 "EHLO
	LGEMRELSE1Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1765988Ab3DEB0m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Apr 2013 21:26:42 -0400
X-AuditID: 9c93016f-b7c18ae000002f5f-de-515e2850a2de
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@kernel.org>, Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Stephane Eranian <eranian@google.com>,
        Andi Kleen <andi@firstfloor.org>, Jiri Olsa <jolsa@redhat.com>,
        David Ahern <dsahern@gmail.com>
Subject: [PATCH 1/8] perf sort: Reorder HISTC_SRCLINE index
Date: Fri,  5 Apr 2013 10:26:31 +0900
Message-Id: <1365125198-8334-2-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1365125198-8334-1-git-send-email-namhyung@kernel.org>
References: <1365125198-8334-1-git-send-email-namhyung@kernel.org>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namhyung Kim <namhyung.kim@lge.com>

It's in common sort dimension so it'd be more natural to place it with
other common column index.

Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
 tools/perf/util/hist.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/perf/util/hist.h b/tools/perf/util/hist.h
index 14c2fe20aa62..6be88dc12b9a 100644
--- a/tools/perf/util/hist.h
+++ b/tools/perf/util/hist.h
@@ -43,12 +43,12 @@ enum hist_column {
 	HISTC_COMM,
 	HISTC_PARENT,
 	HISTC_CPU,
+	HISTC_SRCLINE,
 	HISTC_MISPREDICT,
 	HISTC_SYMBOL_FROM,
 	HISTC_SYMBOL_TO,
 	HISTC_DSO_FROM,
 	HISTC_DSO_TO,
-	HISTC_SRCLINE,
 	HISTC_LOCAL_WEIGHT,
 	HISTC_GLOBAL_WEIGHT,
 	HISTC_MEM_DADDR_SYMBOL,
-- 
1.7.11.7

