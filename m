Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759850AbaGCWIY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2014 18:08:24 -0400
Received: from smtprelay0118.hostedemail.com ([216.40.44.118]:35383 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754073AbaGCWIV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2014 18:08:21 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::,RULES_HIT:41:355:379:541:800:960:973:988:989:1260:1345:1359:1437:1534:1539:1568:1711:1714:1730:1747:1777:1792:2393:2559:2562:3138:3139:3140:3141:3142:3865:5007:6119:6261:7809:7903:7974:10004:10026:10562:10848:11232:11657:11658:11914:12043:12517:12519:12555:13311:13357:14096:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: crack39_2b674b93f080f
X-Filterd-Recvd-Size: 1525
From: Joe Perches <joe@perches.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Jamie Iles <jamie@jamieiles.com>, linux-kernel@vger.kernel.org
Subject: [PATCH 08/16] MAINTAINERS: Update picoxcell patterns
Date: Thu,  3 Jul 2014 15:07:52 -0700
Message-Id: <c5f0498e88894a7428416be9b8a5fa93302d7e07.1404425176.git.joe@perches.com>
X-Mailer: git-send-email 1.8.1.2.459.gbcd45b4.dirty
In-Reply-To: <cover.1404425176.git.joe@perches.com>
References: <cover.1404425176.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix the picoxcell patterns, add the dts directory too.

Signed-off-by: Joe Perches <joe@perches.com>
cc: Jamie Iles <jamie@jamieiles.com>
---
 MAINTAINERS | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index d398875..e0f326c 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -6901,9 +6901,9 @@ M:	Jamie Iles <jamie@jamieiles.com>
 L:	linux-arm-kernel@lists.infradead.org (moderated for non-subscribers)
 T:	git git://github.com/jamieiles/linux-2.6-ji.git
 S:	Supported
+F:	arch/arm/boot/dts/picoxcell*
 F:	arch/arm/mach-picoxcell/
-F:	drivers/*/picoxcell*
-F:	drivers/*/*/picoxcell*
+F:	drivers/crypto/picoxcell*
 
 PIN CONTROL SUBSYSTEM
 M:	Linus Walleij <linus.walleij@linaro.org>
-- 
1.8.1.2.459.gbcd45b4.dirty

