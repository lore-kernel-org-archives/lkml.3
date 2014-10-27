Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751206AbaJ0FmB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2014 01:42:01 -0400
Received: from smtprelay0072.hostedemail.com ([216.40.44.72]:51285 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750761AbaJ0Fl7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2014 01:41:59 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 50,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::,RULES_HIT:41:355:379:541:800:960:967:973:988:989:1260:1277:1311:1313:1314:1345:1373:1431:1437:1515:1516:1518:1534:1541:1593:1594:1711:1714:1730:1747:1777:1792:2393:2525:2561:2564:2682:2685:2828:2859:2933:2937:2939:2942:2945:2947:2951:2954:3022:3138:3139:3140:3141:3142:3351:3698:3770:3867:3934:3936:3938:3941:3944:3947:3950:3953:3956:3959:4321:4659:5007:6261:6642:9015:9025:9388:10004:10400:10848:11232:11658:11914:12043:12517:12519:12555:13069:13311:13357:14096:14097:14394:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: frame51_4b3685a0dad18
X-Filterd-Recvd-Size: 1783
Message-ID: <1414388515.15751.32.camel@perches.com>
Subject: [PATCH] MAINTAINERS: Update ivtv mailing lists as subscriber-only
From: Joe Perches <joe@perches.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Andy Walls <awalls@md.metrocast.net>,
        linux-media <linux-media@vger.kernel.org>
Date: Sun, 26 Oct 2014 22:41:55 -0700
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.12.7-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mark these as subscriber-only mailing lists.

Signed-off-by: Joe Perches <joe@perches.com>
---
I got rejects not moderation emails for patches to these lists...

 MAINTAINERS | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 1b063fc..2e353c7 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -2684,7 +2684,7 @@ F:	drivers/net/wireless/cw1200/
 
 CX18 VIDEO4LINUX DRIVER
 M:	Andy Walls <awalls@md.metrocast.net>
-L:	ivtv-devel@ivtvdriver.org (moderated for non-subscribers)
+L:	ivtv-devel@ivtvdriver.org (subscribers-only)
 L:	linux-media@vger.kernel.org
 T:	git git://linuxtv.org/media_tree.git
 W:	http://linuxtv.org
@@ -5152,7 +5152,7 @@ F:	drivers/media/tuners/it913x*
 
 IVTV VIDEO4LINUX DRIVER
 M:	Andy Walls <awalls@md.metrocast.net>
-L:	ivtv-devel@ivtvdriver.org (moderated for non-subscribers)
+L:	ivtv-devel@ivtvdriver.org (subscribers-only)
 L:	linux-media@vger.kernel.org
 T:	git git://linuxtv.org/media_tree.git
 W:	http://www.ivtvdriver.org


