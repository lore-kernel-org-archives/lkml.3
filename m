Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753239AbbAVRBp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2015 12:01:45 -0500
Received: from mail-la0-f47.google.com ([209.85.215.47]:53661 "EHLO
	mail-la0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751972AbbAVRBl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2015 12:01:41 -0500
From: Rasmus Villemoes <linux@rasmusvillemoes.dk>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: Rasmus Villemoes <linux@rasmusvillemoes.dk>, linux-kernel@vger.kernel.org
Subject: [PATCH] perf/tests: Fix typo in sample-parsing.c
Date: Thu, 22 Jan 2015 18:01:23 +0100
Message-Id: <1421946083-29863-1-git-send-email-linux@rasmusvillemoes.dk>
X-Mailer: git-send-email 2.1.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I'm pretty sure this wasn't supposed to be dead code.

Signed-off-by: Rasmus Villemoes <linux@rasmusvillemoes.dk>
---
 tools/perf/tests/sample-parsing.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/perf/tests/sample-parsing.c b/tools/perf/tests/sample-parsing.c
index 4908c648a597..30c02181e78b 100644
--- a/tools/perf/tests/sample-parsing.c
+++ b/tools/perf/tests/sample-parsing.c
@@ -110,7 +110,7 @@ static bool samples_same(const struct perf_sample *s1,
 
 	if (type & PERF_SAMPLE_STACK_USER) {
 		COMP(user_stack.size);
-		if (memcmp(s1->user_stack.data, s1->user_stack.data,
+		if (memcmp(s1->user_stack.data, s2->user_stack.data,
 			   s1->user_stack.size)) {
 			pr_debug("Samples differ at 'user_stack'\n");
 			return false;
-- 
2.1.3

