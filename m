Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933692Ab3HGVWa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Aug 2013 17:22:30 -0400
Received: from merlin.infradead.org ([205.233.59.134]:47017 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933369Ab3HGVL1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Aug 2013 17:11:27 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 38/47] perf annotate browser: Fix typo
Date: Wed,  7 Aug 2013 18:11:05 -0300
Message-Id: <1375909874-22073-39-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1375909874-22073-1-git-send-email-acme@infradead.org>
References: <1375909874-22073-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by merlin.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ingo Molnar <mingo@kernel.org>

Signed-off-by: Ingo Molnar <mingo@kernel.org>
Link: http://lkml.kernel.org/r/20130802111050.GA29126@gmail.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/ui/browsers/annotate.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/perf/ui/browsers/annotate.c b/tools/perf/ui/browsers/annotate.c
index 7d75497..08545ae 100644
--- a/tools/perf/ui/browsers/annotate.c
+++ b/tools/perf/ui/browsers/annotate.c
@@ -505,7 +505,7 @@ static bool annotate_browser__jump(struct annotate_browser *browser)
 
 	dl = annotate_browser__find_offset(browser, dl->ops.target.offset, &idx);
 	if (dl == NULL) {
-		ui_helpline__puts("Invallid jump offset");
+		ui_helpline__puts("Invalid jump offset");
 		return true;
 	}
 
-- 
1.8.1.4

