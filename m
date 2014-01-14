Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752729AbaANQnA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jan 2014 11:43:00 -0500
Received: from terminus.zytor.com ([198.137.202.10]:52948 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751673AbaANQmx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jan 2014 11:42:53 -0500
Date: Tue, 14 Jan 2014 08:42:33 -0800
From: tip-bot for Yann Droneaud <tipbot@zytor.com>
Message-ID: <tip-26f7f9877234e6b9ed87eff4ca450631bafe0182@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, paulus@samba.org,
        hpa@zytor.com, mingo@kernel.org, a.p.zijlstra@chello.nl,
        ydroneaud@opteya.com, namhyung@kernel.org, jolsa@redhat.com,
        dsahern@gmail.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, acme@redhat.com, a.p.zijlstra@chello.nl,
        ydroneaud@opteya.com, namhyung@kernel.org, jolsa@redhat.com,
        dsahern@gmail.com, tglx@linutronix.de
In-Reply-To: <339d86ad76741ed929defd18541f774b404003b4.1389461371.git.ydroneaud@opteya.com>
References: <339d86ad76741ed929defd18541f774b404003b4.1389461371.git.ydroneaud@opteya.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf tools:
  Remove unused test-volatile-register-var.c
Git-Commit-ID: 26f7f9877234e6b9ed87eff4ca450631bafe0182
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Tue, 14 Jan 2014 08:42:40 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  26f7f9877234e6b9ed87eff4ca450631bafe0182
Gitweb:     http://git.kernel.org/tip/26f7f9877234e6b9ed87eff4ca450631bafe0182
Author:     Yann Droneaud <ydroneaud@opteya.com>
AuthorDate: Sat, 11 Jan 2014 18:48:15 +0100
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Mon, 13 Jan 2014 17:20:05 -0300

perf tools: Remove unused test-volatile-register-var.c

Since commit 01287e2cb7ad, test-volatile-register-var.c is no more built
as part of the automatic feature check.

This patch remove the unneeded file.

Signed-off-by: Yann Droneaud <ydroneaud@opteya.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/339d86ad76741ed929defd18541f774b404003b4.1389461371.git.ydroneaud@opteya.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/config/feature-checks/test-volatile-register-var.c | 6 ------
 1 file changed, 6 deletions(-)

diff --git a/tools/perf/config/feature-checks/test-volatile-register-var.c b/tools/perf/config/feature-checks/test-volatile-register-var.c
deleted file mode 100644
index c9f398d..0000000
--- a/tools/perf/config/feature-checks/test-volatile-register-var.c
+++ /dev/null
@@ -1,6 +0,0 @@
-#include <stdio.h>
-
-int main(void)
-{
-	return puts("hi");
-}
