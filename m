Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932720Ab3LITha (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Dec 2013 14:37:30 -0500
Received: from merlin.infradead.org ([205.233.59.134]:54948 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753229Ab3LIThU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Dec 2013 14:37:20 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Dongsheng Yang <yangds.fnst@cn.fujitsu.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 13/21] perf annotate: Fix typo
Date: Mon,  9 Dec 2013 16:37:02 -0300
Message-Id: <1386617830-18926-14-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1386617830-18926-1-git-send-email-acme@infradead.org>
References: <1386617830-18926-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by merlin.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dongsheng Yang <yangds.fnst@cn.fujitsu.com>

A typo in comment of builtin-annotate.c about 'that'.

Signed-off-by: Dongsheng Yang <yangds.fnst@cn.fujitsu.com>
Link: http://lkml.kernel.org/r/46cb069a4ce21141057a07c0b50baa9968e3228c.1386629050.git.yangds.fnst@cn.fujitsu.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-annotate.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/perf/builtin-annotate.c b/tools/perf/builtin-annotate.c
index 4087ab19823c..6fd52c8fa682 100644
--- a/tools/perf/builtin-annotate.c
+++ b/tools/perf/builtin-annotate.c
@@ -373,7 +373,7 @@ int cmd_annotate(int argc, const char **argv, const char *prefix __maybe_unused)
 
 	if (argc) {
 		/*
-		 * Special case: if there's an argument left then assume tha
+		 * Special case: if there's an argument left then assume that
 		 * it's a symbol filter:
 		 */
 		if (argc > 1)
-- 
1.8.1.4

