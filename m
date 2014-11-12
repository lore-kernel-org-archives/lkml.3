Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752541AbaKLI2Y (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2014 03:28:24 -0500
Received: from mx1.redhat.com ([209.132.183.28]:54647 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752164AbaKLI2U (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2014 03:28:20 -0500
From: WANG Chao <chaowang@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Jiri Olsa <jolsa@kernel.org>, Namhyung Kim <namhyung@kernel.org>,
        Jean Pihet <jean.pihet@linaro.org>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Adrian Hunter <adrian.hunter@intel.com>
Subject: [PATCH] perf test: fix typo in python test
Date: Wed, 12 Nov 2014 16:27:05 +0800
Message-Id: <1415780826-13250-1-git-send-email-chaowang@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Library loading in python syntax should be 'import perf', not 'use perf'.

Signed-off-by: WANG Chao <chaowang@redhat.com>
---
 tools/perf/tests/builtin-test.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/perf/tests/builtin-test.c b/tools/perf/tests/builtin-test.c
index 162c978..4b7d9ab 100644
--- a/tools/perf/tests/builtin-test.c
+++ b/tools/perf/tests/builtin-test.c
@@ -85,7 +85,7 @@ static struct test {
 		.func = test__hists_link,
 	},
 	{
-		.desc = "Try 'use perf' in python, checking link problems",
+		.desc = "Try 'import perf' in python, checking link problems",
 		.func = test__python_use,
 	},
 	{
-- 
1.9.3

