Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759790AbaGCWIQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2014 18:08:16 -0400
Received: from smtprelay0130.hostedemail.com ([216.40.44.130]:59144 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753236AbaGCWIN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2014 18:08:13 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::,RULES_HIT:41:355:379:541:800:960:973:988:989:1260:1345:1359:1534:1539:1567:1711:1714:1730:1747:1777:1792:2393:2559:2562:3138:3139:3140:3141:3142:3872:3876:4321:5007:6261:10004:10026:10848:11232:11657:11658:11914:12043:12517:12519:12555:13311:13357:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: grip31_2a82b344e2363
X-Filterd-Recvd-Size: 1350
From: Joe Perches <joe@perches.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 05/16] MAINTAINERS: Fix ssbi pattern
Date: Thu,  3 Jul 2014 15:07:49 -0700
Message-Id: <4fbca2cc2bf0a35b58b865f21fe60364e157cc35.1404425176.git.joe@perches.com>
X-Mailer: git-send-email 1.8.1.2.459.gbcd45b4.dirty
In-Reply-To: <cover.1404425176.git.joe@perches.com>
References: <cover.1404425176.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Incorrect pattern used, it's not a directory, it's a file.
Fix it.

Signed-off-by: Joe Perches <joe@perches.com>
---
 MAINTAINERS | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 90ee3d6..6d1fc20 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -1143,7 +1143,7 @@ F:	drivers/mmc/host/msm_sdcc.h
 F:	drivers/tty/serial/msm_serial.h
 F:	drivers/tty/serial/msm_serial.c
 F:	drivers/*/pm8???-*
-F:	drivers/mfd/ssbi/
+F:	drivers/mfd/ssbi.c
 F:	include/linux/mfd/pm8xxx/
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/davidb/linux-msm.git
 S:	Maintained
-- 
1.8.1.2.459.gbcd45b4.dirty

