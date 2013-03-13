Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751517Ab3CMEYo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Mar 2013 00:24:44 -0400
Received: from mail-bk0-f47.google.com ([209.85.214.47]:60149 "EHLO
	mail-bk0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750860Ab3CMEYn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Mar 2013 00:24:43 -0400
MIME-Version: 1.0
Date: Wed, 13 Mar 2013 12:24:42 +0800
Message-ID: <CAPgLHd9=EXaH1hv4jeVvTa4tZFsjnx+8+g3zqmmUKqQ5qRqTEA@mail.gmail.com>
Subject: [PATCH -next] perf report: remove duplicated include from builtin-report.c
From: Wei Yongjun <weiyj.lk@gmail.com>
To: a.p.zijlstra@chello.nl, paulus@samba.org, mingo@redhat.com,
        acme@ghostprotocols.net
Cc: yongjun_wei@trendmicro.com.cn, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>

Remove duplicated include.

Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
---
 tools/perf/builtin-report.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/tools/perf/builtin-report.c b/tools/perf/builtin-report.c
index 96b5a7f..67b840c 100644
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

