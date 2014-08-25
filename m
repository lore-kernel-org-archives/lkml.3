Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756179AbaHYQES (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Aug 2014 12:04:18 -0400
Received: from smtprelay0015.hostedemail.com ([216.40.44.15]:48274 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754782AbaHYQER (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Aug 2014 12:04:17 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 64,4,0,,d41d8cd98f00b204,joe@perches.com,:::::,RULES_HIT:41:355:379:541:800:960:968:973:982:988:989:1260:1261:1277:1311:1313:1314:1345:1373:1437:1515:1516:1518:1534:1539:1566:1593:1594:1711:1714:1730:1747:1777:1792:2332:2393:2559:2562:2828:3138:3139:3140:3141:3142:3871:3874:3876:4321:5007:7652:10004:10400:10848:11658:11914:12517:12519:12555:13019:13069:13311:13357:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: neck73_5f64adb49c226
X-Filterd-Recvd-Size: 1297
Message-ID: <1408982654.20683.53.camel@joe-AO725>
Subject: [PATCH] checkpatch: Remove debugging message
From: Joe Perches <joe@perches.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Andy Whitcroft <apw@canonical.com>, LKML <linux-kernel@vger.kernel.org>
Date: Mon, 25 Aug 2014 09:04:14 -0700
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.10.4-0ubuntu2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

An unnecessary --fix debugging left-over is removed.

Signed-off-by: Joe Perches <joe@perches.com>
---
 scripts/checkpatch.pl | 1 -
 1 file changed, 1 deletion(-)

diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
index b385bcb..2152369 100755
--- a/scripts/checkpatch.pl
+++ b/scripts/checkpatch.pl
@@ -3749,7 +3749,6 @@ sub process {
 			if (ERROR("SPACING",
 				  "space prohibited before that close parenthesis ')'\n" . $herecurr) &&
 			    $fix) {
-				print("fixlinenr: <$fixlinenr> fixed[fixlinenr]: <$fixed[$fixlinenr]>\n");
 				$fixed[$fixlinenr] =~
 				    s/\s+\)/\)/;
 			}



