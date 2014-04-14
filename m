Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754581AbaDNOwV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2014 10:52:21 -0400
Received: from terminus.zytor.com ([198.137.202.10]:46527 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751356AbaDNOwU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2014 10:52:20 -0400
Date: Mon, 14 Apr 2014 07:51:43 -0700
From: tip-bot for Namhyung Kim <tipbot@zytor.com>
Message-ID: <tip-5e09714b0e877d5d062530aae4061074d864243f@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, paulus@samba.org,
        hpa@zytor.com, mingo@kernel.org, a.p.zijlstra@chello.nl,
        namhyung.kim@lge.com, namhyung@kernel.org, jolsa@redhat.com,
        dsahern@gmail.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, acme@redhat.com, a.p.zijlstra@chello.nl,
        namhyung.kim@lge.com, namhyung@kernel.org, jolsa@redhat.com,
        dsahern@gmail.com, tglx@linutronix.de
In-Reply-To: <1395193578-27098-1-git-send-email-namhyung@kernel.org>
References: <1395193578-27098-1-git-send-email-namhyung@kernel.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] perf top:
  Fix documentation of invalid -s option
Git-Commit-ID: 5e09714b0e877d5d062530aae4061074d864243f
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

Commit-ID:  5e09714b0e877d5d062530aae4061074d864243f
Gitweb:     http://git.kernel.org/tip/5e09714b0e877d5d062530aae4061074d864243f
Author:     Namhyung Kim <namhyung@kernel.org>
AuthorDate: Wed, 19 Mar 2014 10:46:18 +0900
Committer:  Jiri Olsa <jolsa@redhat.com>
CommitDate: Mon, 14 Apr 2014 12:54:59 +0200

perf top: Fix documentation of invalid -s option

On perf top, the -s option is used for --sort, but the man page
contains invalid documentation of -s option for --sym-annotate.

Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Cc: David Ahern <dsahern@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Namhyung Kim <namhyung.kim@lge.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/1395193578-27098-1-git-send-email-namhyung@kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Jiri Olsa <jolsa@redhat.com>
---
 tools/perf/Documentation/perf-top.txt | 1 -
 1 file changed, 1 deletion(-)

diff --git a/tools/perf/Documentation/perf-top.txt b/tools/perf/Documentation/perf-top.txt
index cdd8d49..976b00c 100644
--- a/tools/perf/Documentation/perf-top.txt
+++ b/tools/perf/Documentation/perf-top.txt
@@ -87,7 +87,6 @@ Default is to monitor all CPUS.
 --realtime=<priority>::
 	Collect data with this RT SCHED_FIFO priority.
 
--s <symbol>::
 --sym-annotate=<symbol>::
         Annotate this symbol.
 
