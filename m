Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757668Ab3CULcy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Mar 2013 07:32:54 -0400
Received: from terminus.zytor.com ([198.137.202.10]:56667 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752147Ab3CULcx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Mar 2013 07:32:53 -0400
Date: Thu, 21 Mar 2013 04:31:17 -0700
From: tip-bot for Wei Yongjun <tipbot@zytor.com>
Message-ID: <tip-db3c6bf811581c626471a6aecdf0024575b707d7@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, paulus@samba.org,
        mingo@redhat.com, hpa@zytor.com, mingo@kernel.org,
        a.p.zijlstra@chello.nl, yongjun_wei@trendmicro.com.cn,
        tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, mingo@redhat.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, acme@redhat.com, a.p.zijlstra@chello.nl,
        yongjun_wei@trendmicro.com.cn, tglx@linutronix.de
In-Reply-To: <CAPgLHd9=EXaH1hv4jeVvTa4tZFsjnx+8+g3zqmmUKqQ5qRqTEA@mail.gmail.com>
References: <CAPgLHd9=EXaH1hv4jeVvTa4tZFsjnx+8+g3zqmmUKqQ5qRqTEA@mail.gmail.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf report: Remove duplicated include
Git-Commit-ID: db3c6bf811581c626471a6aecdf0024575b707d7
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Thu, 21 Mar 2013 04:31:27 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  db3c6bf811581c626471a6aecdf0024575b707d7
Gitweb:     http://git.kernel.org/tip/db3c6bf811581c626471a6aecdf0024575b707d7
Author:     Wei Yongjun <yongjun_wei@trendmicro.com.cn>
AuthorDate: Wed, 13 Mar 2013 12:24:42 +0800
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Fri, 15 Mar 2013 13:06:08 -0300

perf report: Remove duplicated include

Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/CAPgLHd9=EXaH1hv4jeVvTa4tZFsjnx+8+g3zqmmUKqQ5qRqTEA@mail.gmail.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-report.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/tools/perf/builtin-report.c b/tools/perf/builtin-report.c
index 3f4a79b..296bd21 100644
--- a/tools/perf/builtin-report.c
+++ b/tools/perf/builtin-report.c
@@ -13,7 +13,6 @@
 #include "util/annotate.h"
 #include "util/color.h"
 #include <linux/list.h>
-#include "util/cache.h"
 #include <linux/rbtree.h>
 #include "util/symbol.h"
 #include "util/callchain.h"
