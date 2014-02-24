Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753311AbaBXIJx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Feb 2014 03:09:53 -0500
Received: from LGEMRELSE6Q.lge.com ([156.147.1.121]:45874 "EHLO
	lgemrelse6q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753035AbaBXIJq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Feb 2014 03:09:46 -0500
X-Original-SENDERIP: 10.177.220.181
X-Original-MAILFROM: namhyung@kernel.org
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@kernel.org>,
        Paul Mackerras <paulus@samba.org>, Namhyung Kim <namhyung.kim@lge.com>,
        Namhyung Kim <namhyung@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, Jiri Olsa <jolsa@redhat.com>,
        David Ahern <dsahern@gmail.com>, Andi Kleen <andi@firstfloor.org>
Subject: [PATCH 8/8] perf tools: Show absolute percentage by default
Date: Mon, 24 Feb 2014 17:09:28 +0900
Message-Id: <1393229368-31412-9-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1393229368-31412-1-git-send-email-namhyung@kernel.org>
References: <1393229368-31412-1-git-send-email-namhyung@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now perf report will show absolute percentage on filter entries by
default.

Suggested-by: Jiri Olsa <jolsa@redhat.com>
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
 tools/perf/util/symbol.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/tools/perf/util/symbol.c b/tools/perf/util/symbol.c
index f2382f2ff2f0..46e2ede12c51 100644
--- a/tools/perf/util/symbol.c
+++ b/tools/perf/util/symbol.c
@@ -33,7 +33,6 @@ struct symbol_conf symbol_conf = {
 	.try_vmlinux_path = true,
 	.annotate_src	  = true,
 	.demangle	  = true,
-	.filter_relative  = true,
 	.symfs            = "",
 };
 
-- 
1.7.11.7

