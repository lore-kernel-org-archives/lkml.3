Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757807Ab3KNU1v (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Nov 2013 15:27:51 -0500
Received: from merlin.infradead.org ([205.233.59.134]:36290 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756772Ab3KNUZY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Nov 2013 15:25:24 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Davidlohr Bueso <davidlohr@hp.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 02/10] perf tools: Remove trivial extra semincolon
Date: Thu, 14 Nov 2013 17:25:07 -0300
Message-Id: <1384460715-23198-3-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1384460715-23198-1-git-send-email-acme@infradead.org>
References: <1384460715-23198-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by merlin.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Davidlohr Bueso <davidlohr@hp.com>

Accidentally ran into these, get rid of them.

Signed-off-by: Davidlohr Bueso <davidlohr@hp.com>
Link: http://lkml.kernel.org/r/1384323864.2527.8.camel@buesod1.americas.hpqcorp.net
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/ui/browser.c  | 2 +-
 tools/perf/util/evlist.c | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/tools/perf/ui/browser.c b/tools/perf/ui/browser.c
index bbc782e364b0..3648d4ec041f 100644
--- a/tools/perf/ui/browser.c
+++ b/tools/perf/ui/browser.c
@@ -680,7 +680,7 @@ static void __ui_browser__line_arrow_down(struct ui_browser *browser,
 	if (end >= browser->top_idx + browser->height)
 		end_row = browser->height - 1;
 	else
-		end_row = end - browser->top_idx;;
+		end_row = end - browser->top_idx;
 
 	ui_browser__gotorc(browser, row, column);
 	SLsmg_draw_vline(end_row - row + 1);
diff --git a/tools/perf/util/evlist.c b/tools/perf/util/evlist.c
index dc6fa3fbb180..5ce2ace2d6c1 100644
--- a/tools/perf/util/evlist.c
+++ b/tools/perf/util/evlist.c
@@ -1148,7 +1148,7 @@ size_t perf_evlist__fprintf(struct perf_evlist *evlist, FILE *fp)
 				   perf_evsel__name(evsel));
 	}
 
-	return printed + fprintf(fp, "\n");;
+	return printed + fprintf(fp, "\n");
 }
 
 int perf_evlist__strerror_tp(struct perf_evlist *evlist __maybe_unused,
-- 
1.8.1.4

