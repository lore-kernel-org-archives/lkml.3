Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755019AbaG3DjD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2014 23:39:03 -0400
Received: from smtprelay0241.hostedemail.com ([216.40.44.241]:35859 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754942AbaG3DjA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2014 23:39:00 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::,RULES_HIT:41:355:379:541:800:960:973:988:989:1260:1345:1359:1437:1534:1541:1711:1714:1730:1747:1777:1792:2393:2559:2562:2895:3138:3139:3140:3141:3142:3351:3865:3867:3872:4321:5007:6261:10004:10026:10848:11232:11657:11658:11914:12043:12517:12519:12555:13311:13357:14093:14096:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: chalk04_4e69f0aba4561
X-Filterd-Recvd-Size: 1976
From: Joe Perches <joe@perches.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Linus Walleij <linus.walleij@linaro.org>,
        Alessandro Rubini <rubini@unipv.it>, linux-kernel@vger.kernel.org
Subject: [PATCH 6/6] MAINTAINERS: Update nomadik patterns
Date: Tue, 29 Jul 2014 20:38:44 -0700
Message-Id: <b409bc59d95336f26b13ce37a5ae3d06417aa814.1406691397.git.joe@perches.com>
X-Mailer: git-send-email 1.8.1.2.459.gbcd45b4.dirty
In-Reply-To: <cover.1406691397.git.joe@perches.com>
References: <cover.1406691397.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

commit 3a19805920f1 ("pinctrl: nomadik: move all Nomadik drivers to subdir")
move the files, update the patterns

Signed-off-by: Joe Perches <joe@perches.com>
cc: Linus Walleij <linus.walleij@linaro.org>
cc: Alessandro Rubini <rubini@unipv.it>
---
 MAINTAINERS | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 70f157e..09603b9 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -1155,6 +1155,7 @@ M:	Linus Walleij <linus.walleij@linaro.org>
 L:	linux-arm-kernel@lists.infradead.org (moderated for non-subscribers)
 S:	Maintained
 F:	arch/arm/mach-nomadik/
+F:	drivers/pinctrl/nomadik/
 F:	drivers/i2c/busses/i2c-nomadik.c
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/linusw/linux-nomadik.git
 
@@ -1432,7 +1433,8 @@ F:	drivers/mfd/abx500*
 F:	drivers/mfd/ab8500*
 F:	drivers/mfd/dbx500*
 F:	drivers/mfd/db8500*
-F:	drivers/pinctrl/pinctrl-nomadik*
+F:	drivers/pinctrl/nomadik/pinctrl-ab*
+F:	drivers/pinctrl/nomadik/pinctrl-nomadik*
 F:	drivers/rtc/rtc-ab8500.c
 F:	drivers/rtc/rtc-pl031.c
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/linusw/linux-stericsson.git
-- 
1.8.1.2.459.gbcd45b4.dirty

