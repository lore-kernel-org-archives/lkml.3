Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756718Ab3HLKXL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Aug 2013 06:23:11 -0400
Received: from terminus.zytor.com ([198.137.202.10]:48077 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755067Ab3HLKXG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Aug 2013 06:23:06 -0400
Date: Mon, 12 Aug 2013 03:22:53 -0700
From: tip-bot for Ingo Molnar <tipbot@zytor.com>
Message-ID: <tip-e6f653888844f3b86f4274f03e731a3eacd22c49@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, hpa@zytor.com,
        mingo@kernel.org, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        acme@redhat.com, tglx@linutronix.de
In-Reply-To: <20130802111050.GA29126@gmail.com>
References: <20130802111050.GA29126@gmail.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf annotate browser: Fix typo
Git-Commit-ID: e6f653888844f3b86f4274f03e731a3eacd22c49
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Mon, 12 Aug 2013 03:22:59 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  e6f653888844f3b86f4274f03e731a3eacd22c49
Gitweb:     http://git.kernel.org/tip/e6f653888844f3b86f4274f03e731a3eacd22c49
Author:     Ingo Molnar <mingo@kernel.org>
AuthorDate: Fri, 2 Aug 2013 13:10:50 +0200
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Wed, 7 Aug 2013 17:35:37 -0300

perf annotate browser: Fix typo

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
 
