Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754358Ab3KNXfn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Nov 2013 18:35:43 -0500
Received: from smtprelay0042.hostedemail.com ([216.40.44.42]:60943 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752718Ab3KNXfh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Nov 2013 18:35:37 -0500
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::,RULES_HIT:41:355:379:541:800:960:973:988:989:1260:1261:1277:1311:1313:1314:1345:1373:1437:1515:1516:1518:1534:1538:1566:1593:1594:1711:1714:1730:1747:1777:1792:2393:2559:2562:2828:3138:3139:3140:3141:3142:3865:4321:4418:5007:7652:10004:10400:10848:11232:11657:11658:11914:12517:12519:12555:12679:13069:13311:13357,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: chess74_13abf49b2a00c
X-Filterd-Recvd-Size: 1217
Message-ID: <1384472134.2897.35.camel@joe-AO722>
Subject: [PATCH] MAINTAINERS: Remove F: entry for kernel/wait.c
From: Joe Perches <joe@perches.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@kernel.org>, LKML <linux-kernel@vger.kernel.org>
Date: Thu, 14 Nov 2013 15:35:34 -0800
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.8.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

commit 7a6354e241 ("sched: Move wait.c into kernel/sched/")
moved the file into an already maintained section.

Delete the F: pattern line.

Signed-off-by: Joe Perches <joe@perches.com>
---
 MAINTAINERS | 1 -
 1 file changed, 1 deletion(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 239c751..3f85561 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -7361,7 +7361,6 @@ S:	Maintained
 F:	kernel/sched/
 F:	include/linux/sched.h
 F:	include/uapi/linux/sched.h
-F:	kernel/wait.c
 F:	include/linux/wait.h
 
 SCORE ARCHITECTURE


