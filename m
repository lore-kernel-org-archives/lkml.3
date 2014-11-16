Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751499AbaKPUJ7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Nov 2014 15:09:59 -0500
Received: from smtprelay0171.hostedemail.com ([216.40.44.171]:44680 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751287AbaKPUJ5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Nov 2014 15:09:57 -0500
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::,RULES_HIT:41:355:379:541:800:960:966:973:988:989:1260:1345:1359:1437:1534:1538:1566:1711:1714:1730:1747:1777:1792:2196:2199:2393:2559:2562:3138:3139:3140:3141:3142:3865:4385:5007:6261:9010:10004:10848:11026:11658:11914:12517:12519:12555:13311:13357:14394:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: scent12_56a17111da125
X-Filterd-Recvd-Size: 1467
From: Joe Perches <joe@perches.com>
To: Ionut Alexa <ionut.m.alexa@gmail.com>, linux-kernel@vger.kernel.org
Cc: Al Viro <viro@ZenIV.linux.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [UNNECESSARY PATCH 13/16] signal: Move label to first column
Date: Sun, 16 Nov 2014 12:09:20 -0800
Message-Id: <99b01af490f75ae3bc1f295c77c337954310cbed.1416167046.git.joe@perches.com>
X-Mailer: git-send-email 2.1.2
In-Reply-To: <20141116180059.GS7996@ZenIV.linux.org.uk>
References: <20141116180059.GS7996@ZenIV.linux.org.uk>
In-Reply-To: <cover.1416167046.git.joe@perches.com>
References: <cover.1416167046.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use the more common kernel style.

Signed-off-by: Joe Perches <joe@perches.com>
---
 kernel/signal.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/signal.c b/kernel/signal.c
index 15ce05d..9b133eb 100644
--- a/kernel/signal.c
+++ b/kernel/signal.c
@@ -566,7 +566,7 @@ static void collect_signal(int sig, struct sigpending *list, siginfo_t *info)
 	sigdelset(&list->signal, sig);
 
 	if (first) {
-	still_pending:
+still_pending:
 		list_del_init(&first->list);
 		copy_siginfo(info, &first->info);
 		__sigqueue_free(first);
-- 
2.1.2

