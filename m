Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751421AbaKPUJw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Nov 2014 15:09:52 -0500
Received: from smtprelay0120.hostedemail.com ([216.40.44.120]:33010 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751287AbaKPUJq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Nov 2014 15:09:46 -0500
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::,RULES_HIT:41:355:379:541:800:960:973:988:989:1260:1345:1359:1437:1534:1538:1568:1711:1714:1730:1747:1777:1792:2393:2559:2562:3138:3139:3140:3141:3142:3865:3866:3867:3868:3872:4321:5007:6261:10004:10848:11026:11658:11914:12296:12517:12519:12555:13311:13357:14394:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: beam00_55166b703c10f
X-Filterd-Recvd-Size: 1476
From: Joe Perches <joe@perches.com>
To: Ionut Alexa <ionut.m.alexa@gmail.com>, linux-kernel@vger.kernel.org
Cc: Al Viro <viro@ZenIV.linux.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [UNNECESSARY PATCH 08/16] signal: Remove unnecessary return
Date: Sun, 16 Nov 2014 12:09:15 -0800
Message-Id: <8d784dd989281ff9adc1382d6819c3174eee2d6f.1416167046.git.joe@perches.com>
X-Mailer: git-send-email 2.1.2
In-Reply-To: <20141116180059.GS7996@ZenIV.linux.org.uk>
References: <20141116180059.GS7996@ZenIV.linux.org.uk>
In-Reply-To: <cover.1416167046.git.joe@perches.com>
References: <cover.1416167046.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

void functions don't need returns and end of function definition.

Signed-off-by: Joe Perches <joe@perches.com>
---
 kernel/signal.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/kernel/signal.c b/kernel/signal.c
index baddb92..ccd57a3 100644
--- a/kernel/signal.c
+++ b/kernel/signal.c
@@ -996,7 +996,6 @@ static void complete_signal(int sig, struct task_struct *p, int group)
 	 * Tell the chosen thread to wake up and dequeue it.
 	 */
 	signal_wake_up(t, sig == SIGKILL);
-	return;
 }
 
 static inline int legacy_queue(struct sigpending *signals, int sig)
-- 
2.1.2

