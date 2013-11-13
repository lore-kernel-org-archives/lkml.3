Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758400Ab3KMGYd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Nov 2013 01:24:33 -0500
Received: from g1t0027.austin.hp.com ([15.216.28.34]:18628 "EHLO
	g1t0027.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751357Ab3KMGY0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Nov 2013 01:24:26 -0500
Message-ID: <1384323864.2527.8.camel@buesod1.americas.hpqcorp.net>
Subject: [PATCH] tools, perf: remove trivial extra semincolon
From: Davidlohr Bueso <davidlohr@hp.com>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: linux-kernel@vger.kernel.org
Date: Tue, 12 Nov 2013 22:24:24 -0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4 (3.6.4-3.fc18) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Accidentally ran into these, get rid of them.

Signed-off-by: Davidlohr Bueso <davidlohr@hp.com>
---
 tools/perf/ui/browser.c  | 2 +-
 tools/perf/util/evlist.c | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/tools/perf/ui/browser.c b/tools/perf/ui/browser.c
index bbc782e..3648d4e 100644
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
index b939221..1038f4a 100644
--- a/tools/perf/util/evlist.c
+++ b/tools/perf/util/evlist.c
@@ -1135,7 +1135,7 @@ size_t perf_evlist__fprintf(struct perf_evlist *evlist, FILE *fp)
 				   perf_evsel__name(evsel));
 	}
 
-	return printed + fprintf(fp, "\n");;
+	return printed + fprintf(fp, "\n");
 }
 
 int perf_evlist__strerror_tp(struct perf_evlist *evlist __maybe_unused,
-- 
1.8.1.4



