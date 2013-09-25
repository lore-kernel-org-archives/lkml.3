Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754164Ab3IYTy5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Sep 2013 15:54:57 -0400
Received: from smtprelay0214.hostedemail.com ([216.40.44.214]:37386 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751315Ab3IYTy4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Sep 2013 15:54:56 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 50,0,0,,d41d8cd98f00b204,joe@perches.com,:::::,RULES_HIT:41:355:379:541:800:960:967:973:988:989:1260:1261:1277:1311:1313:1314:1345:1373:1437:1515:1516:1518:1534:1540:1568:1593:1594:1711:1714:1730:1747:1777:1792:2393:2525:2561:2564:2682:2685:2828:2859:2933:2937:2939:2942:2945:2947:2951:2954:3022:3138:3139:3140:3141:3142:3872:3876:3934:3936:3938:3941:3944:3947:3950:3953:3956:3959:4321:5007:7652:7809:8599:9025:9388:10004:10049:10400:10848:11232:11658:11914:12043:12114:12517:12519:12555:13069:13311:13357:13846,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: blade06_821b262514618
X-Filterd-Recvd-Size: 1588
Message-ID: <1380138892.17366.24.camel@joe-AO722>
Subject: [PATCH] MAINTAINERS: wimax@linuxwimax.org is subscribers-only
From: Joe Perches <joe@perches.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Inaky Perez-Gonzalez <inaky.perez-gonzalez@intel.com>
Date: Wed, 25 Sep 2013 12:54:52 -0700
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mark it so.

Signed-off-by: Joe Perches <joe@perches.com>
---
 MAINTAINERS | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index e61c2e8..a386a22 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -4414,7 +4414,7 @@ F:	arch/x86/kernel/tboot.c
 INTEL WIRELESS WIMAX CONNECTION 2400
 M:	Inaky Perez-Gonzalez <inaky.perez-gonzalez@intel.com>
 M:	linux-wimax@intel.com
-L:	wimax@linuxwimax.org
+L:	wimax@linuxwimax.org (subscribers-only)
 S:	Supported
 W:	http://linuxwimax.org
 F:	Documentation/wimax/README.i2400m
@@ -9225,7 +9225,7 @@ F:	drivers/media/rc/winbond-cir.c
 WIMAX STACK
 M:	Inaky Perez-Gonzalez <inaky.perez-gonzalez@intel.com>
 M:	linux-wimax@intel.com
-L:	wimax@linuxwimax.org
+L:	wimax@linuxwimax.org (subscribers-only)
 S:	Supported
 W:	http://linuxwimax.org
 F:	Documentation/wimax/README.wimax


