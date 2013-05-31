Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755256Ab3EaLYw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 May 2013 07:24:52 -0400
Received: from terminus.zytor.com ([198.137.202.10]:56550 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751152Ab3EaLYn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 May 2013 07:24:43 -0400
Date: Fri, 31 May 2013 04:24:12 -0700
From: tip-bot for Namhyung Kim <tipbot@zytor.com>
Message-ID: <tip-dfd3b2fd485e3969a30b28e70aabfefa90b81c9c@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, eranian@google.com,
        paulus@samba.org, hpa@zytor.com, mingo@kernel.org, andi@firstfloor.org,
        a.p.zijlstra@chello.nl, namhyung.kim@lge.com, namhyung@kernel.org,
        jolsa@redhat.com, dsahern@gmail.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, paulus@samba.org,
        eranian@google.com, linux-kernel@vger.kernel.org, acme@redhat.com,
        andi@firstfloor.org, a.p.zijlstra@chello.nl, namhyung.kim@lge.com,
        namhyung@kernel.org, jolsa@redhat.com, dsahern@gmail.com,
        tglx@linutronix.de
In-Reply-To: <1365125198-8334-2-git-send-email-namhyung@kernel.org>
References: <1365125198-8334-2-git-send-email-namhyung@kernel.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf sort: Reorder HISTC_SRCLINE index
Git-Commit-ID: dfd3b2fd485e3969a30b28e70aabfefa90b81c9c
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  dfd3b2fd485e3969a30b28e70aabfefa90b81c9c
Gitweb:     http://git.kernel.org/tip/dfd3b2fd485e3969a30b28e70aabfefa90b81c9c
Author:     Namhyung Kim <namhyung.kim@lge.com>
AuthorDate: Fri, 5 Apr 2013 10:26:31 +0900
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Tue, 28 May 2013 16:23:55 +0300

perf sort: Reorder HISTC_SRCLINE index

It's in common sort dimension so it'd be more natural to place it with
other common column index.

Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Cc: Andi Kleen <andi@firstfloor.org>
Cc: David Ahern <dsahern@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/r/1365125198-8334-2-git-send-email-namhyung@kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/hist.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/perf/util/hist.h b/tools/perf/util/hist.h
index 14c2fe2..6be88dc 100644
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
