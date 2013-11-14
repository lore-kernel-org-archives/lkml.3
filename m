Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753374Ab3KNW7w (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Nov 2013 17:59:52 -0500
Received: from smtprelay0064.hostedemail.com ([216.40.44.64]:42810 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751878Ab3KNW7r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Nov 2013 17:59:47 -0500
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::,RULES_HIT:41:355:379:541:800:960:973:988:989:1260:1261:1277:1311:1313:1314:1345:1373:1437:1515:1516:1518:1534:1539:1567:1593:1594:1711:1714:1730:1747:1777:1792:2393:2559:2562:2828:2895:3138:3139:3140:3141:3142:3865:3867:4321:5007:6119:7652:7809:8957:10004:10400:10848:11232:11658:11914:12517:12519:12555:13069:13311:13357,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: clock56_8f7e5c37fb615
X-Filterd-Recvd-Size: 1305
Message-ID: <1384469985.2897.32.camel@joe-AO722>
Subject: [PATCH] MAINTAINERS: Update lockdep section
From: Joe Perches <joe@perches.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@kernel.org>, LKML <linux-kernel@vger.kernel.org>
Date: Thu, 14 Nov 2013 14:59:45 -0800
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.8.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

commit 8eddac3f10 ("locking: Move the lockdep code to kernel/locking/")
moved the files.  Update the pattern

Signed-off-by: Joe Perches <joe@perches.com>
---
 MAINTAINERS | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index f3ef1d1..239c751 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -5236,7 +5236,7 @@ S:	Maintained
 F:	Documentation/lockdep*.txt
 F:	Documentation/lockstat.txt
 F:	include/linux/lockdep.h
-F:	kernel/lockdep*
+F:	kernel/locking/
 
 LOGICAL DISK MANAGER SUPPORT (LDM, Windows 2000/XP/Vista Dynamic Disks)
 M:	"Richard Russon (FlatCap)" <ldm@flatcap.org>


