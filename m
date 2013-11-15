Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755519Ab3KOHZk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Nov 2013 02:25:40 -0500
Received: from terminus.zytor.com ([198.137.202.10]:50302 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754065Ab3KOHY6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Nov 2013 02:24:58 -0500
Date: Thu, 14 Nov 2013 23:24:41 -0800
From: tip-bot for Davidlohr Bueso <tipbot@zytor.com>
Message-ID: <tip-b222213936ef7d48908be2fab7639dd535c88045@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, hpa@zytor.com,
        mingo@kernel.org, tglx@linutronix.de, davidlohr@hp.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        acme@redhat.com, tglx@linutronix.de, davidlohr@hp.com
In-Reply-To: <1384323864.2527.8.camel@buesod1.americas.hpqcorp.net>
References: <1384323864.2527.8.camel@buesod1.americas.hpqcorp.net>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] perf tools: Remove trivial extra semincolon
Git-Commit-ID: b222213936ef7d48908be2fab7639dd535c88045
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Thu, 14 Nov 2013 23:24:47 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  b222213936ef7d48908be2fab7639dd535c88045
Gitweb:     http://git.kernel.org/tip/b222213936ef7d48908be2fab7639dd535c88045
Author:     Davidlohr Bueso <davidlohr@hp.com>
AuthorDate: Tue, 12 Nov 2013 22:24:24 -0800
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Thu, 14 Nov 2013 15:59:38 -0300

perf tools: Remove trivial extra semincolon

Accidentally ran into these, get rid of them.

Signed-off-by: Davidlohr Bueso <davidlohr@hp.com>
Link: http://lkml.kernel.org/r/1384323864.2527.8.camel@buesod1.americas.hpqcorp.net
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
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
index dc6fa3f..5ce2ace 100644
--- a/tools/perf/util/evlist.c
+++ b/tools/perf/util/evlist.c
@@ -1148,7 +1148,7 @@ size_t perf_evlist__fprintf(struct perf_evlist *evlist, FILE *fp)
 				   perf_evsel__name(evsel));
 	}
 
-	return printed + fprintf(fp, "\n");;
+	return printed + fprintf(fp, "\n");
 }
 
 int perf_evlist__strerror_tp(struct perf_evlist *evlist __maybe_unused,
