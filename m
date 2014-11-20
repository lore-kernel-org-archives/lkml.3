Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756527AbaKTHh5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Nov 2014 02:37:57 -0500
Received: from terminus.zytor.com ([198.137.202.10]:43808 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756352AbaKTHhz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Nov 2014 02:37:55 -0500
Date: Wed, 19 Nov 2014 23:37:27 -0800
From: tip-bot for WANG Chao <tipbot@zytor.com>
Message-ID: <tip-887e73d7f42c6a146b572a0577e9875ccca66f37@git.kernel.org>
Cc: tglx@linutronix.de, mingo@kernel.org, mingo@redhat.com,
        a.p.zijlstra@chello.nl, paulus@samba.org, jolsa@kernel.org,
        chaowang@redhat.com, linux-kernel@vger.kernel.org,
        adrian.hunter@intel.com, acme@redhat.com,
        masami.hiramatsu.pt@hitachi.com, namhyung@kernel.org, hpa@zytor.com,
        jean.pihet@linaro.org
Reply-To: paulus@samba.org, jolsa@kernel.org, a.p.zijlstra@chello.nl,
        chaowang@redhat.com, linux-kernel@vger.kernel.org, mingo@kernel.org,
        tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
        jean.pihet@linaro.org, adrian.hunter@intel.com, acme@redhat.com,
        masami.hiramatsu.pt@hitachi.com, namhyung@kernel.org
In-Reply-To: <1415780826-13250-1-git-send-email-chaowang@redhat.com>
References: <1415780826-13250-1-git-send-email-chaowang@redhat.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf test: fix typo in python test
Git-Commit-ID: 887e73d7f42c6a146b572a0577e9875ccca66f37
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

Commit-ID:  887e73d7f42c6a146b572a0577e9875ccca66f37
Gitweb:     http://git.kernel.org/tip/887e73d7f42c6a146b572a0577e9875ccca66f37
Author:     WANG Chao <chaowang@redhat.com>
AuthorDate: Wed, 12 Nov 2014 16:27:05 +0800
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Wed, 19 Nov 2014 12:33:47 -0300

perf test: fix typo in python test

Library loading in python syntax should be 'import perf', not 'use perf'.

Signed-off-by: WANG Chao <chaowang@redhat.com>
Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Jean Pihet <jean.pihet@linaro.org>
Cc: Jiri Olsa <jolsa@kernel.org>
Cc: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/1415780826-13250-1-git-send-email-chaowang@redhat.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
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
