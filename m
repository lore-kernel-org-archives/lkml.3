Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933432Ab3JOFc2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Oct 2013 01:32:28 -0400
Received: from terminus.zytor.com ([198.137.202.10]:33649 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933398Ab3JOFcX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Oct 2013 01:32:23 -0400
Date: Mon, 14 Oct 2013 22:32:09 -0700
From: tip-bot for Ingo Molnar <tipbot@zytor.com>
Message-ID: <tip-3fae82db558468c01f36eb6398e9459ac240e697@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, hpa@zytor.com,
        mingo@kernel.org, a.p.zijlstra@chello.nl, namhyung@kernel.org,
        jolsa@redhat.com, dsahern@gmail.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        acme@redhat.com, a.p.zijlstra@chello.nl, namhyung@kernel.org,
        jolsa@redhat.com, dsahern@gmail.com, tglx@linutronix.de
In-Reply-To: <1381312169-17354-4-git-send-email-mingo@kernel.org>
References: <1381312169-17354-4-git-send-email-mingo@kernel.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf tools:
  Align perf version output to other build messages
Git-Commit-ID: 3fae82db558468c01f36eb6398e9459ac240e697
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Mon, 14 Oct 2013 22:32:15 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  3fae82db558468c01f36eb6398e9459ac240e697
Gitweb:     http://git.kernel.org/tip/3fae82db558468c01f36eb6398e9459ac240e697
Author:     Ingo Molnar <mingo@kernel.org>
AuthorDate: Wed, 9 Oct 2013 11:49:28 +0200
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Fri, 11 Oct 2013 12:18:10 -0300

perf tools: Align perf version output to other build messages

Before:

  CC util/pmu.o
  CC util/parse-events.o
PERF_VERSION = 3.12.rc4.g1b30c
  CC util/parse-events-flex.o
  GEN perf-archive

After:

  CC util/pmu.o
  CC util/parse-events.o
  PERF_VERSION = 3.12.rc4.g1b30c
  CC util/parse-events-flex.o
  GEN perf-archive

Signed-off-by: Ingo Molnar <mingo@kernel.org>
Cc: David Ahern <dsahern@gmail.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/1381312169-17354-4-git-send-email-mingo@kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/PERF-VERSION-GEN | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/perf/util/PERF-VERSION-GEN b/tools/perf/util/PERF-VERSION-GEN
index 15a77b7..ce7a804 100755
--- a/tools/perf/util/PERF-VERSION-GEN
+++ b/tools/perf/util/PERF-VERSION-GEN
@@ -40,7 +40,7 @@ else
 	VC=unset
 fi
 test "$VN" = "$VC" || {
-	echo >&2 "PERF_VERSION = $VN"
+	echo >&2 "  PERF_VERSION = $VN"
 	echo "#define PERF_VERSION \"$VN\"" >$GVF
 }
 
