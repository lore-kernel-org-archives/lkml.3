Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759986AbaGCWLN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2014 18:11:13 -0400
Received: from smtprelay0194.hostedemail.com ([216.40.44.194]:33604 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1759791AbaGCWIS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2014 18:08:18 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::,RULES_HIT:41:355:379:541:800:960:966:973:988:989:1260:1345:1359:1534:1538:1566:1711:1714:1730:1747:1777:1792:2196:2199:2393:2559:2562:3138:3139:3140:3141:3142:3622:3876:3877:4321:4385:5007:6114:6119:6261:6642:7514:7809:10004:10026:10848:11232:11658:11914:12043:12517:12519:12555:13311:13357:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: wood07_2b1d7fbf4940a
X-Filterd-Recvd-Size: 1290
From: Joe Perches <joe@perches.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 07/16] MAINTAINERS: Fix PXA3xx NAND FLASH DRIVER pattern
Date: Thu,  3 Jul 2014 15:07:51 -0700
Message-Id: <5c55003d96ab481799f9d7974e3144842a30bde0.1404425176.git.joe@perches.com>
X-Mailer: git-send-email 1.8.1.2.459.gbcd45b4.dirty
In-Reply-To: <cover.1404425176.git.joe@perches.com>
References: <cover.1404425176.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use underscore, not dash

Signed-off-by: Joe Perches <joe@perches.com>
---
 MAINTAINERS | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 0dab840..d398875 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -7179,7 +7179,7 @@ PXA3xx NAND FLASH DRIVER
 M:	Ezequiel Garcia <ezequiel.garcia@free-electrons.com>
 L:	linux-mtd@lists.infradead.org
 S:	Maintained
-F:	drivers/mtd/nand/pxa3xx-nand.c
+F:	drivers/mtd/nand/pxa3xx_nand.c
 
 MMP SUPPORT
 M:	Eric Miao <eric.y.miao@gmail.com>
-- 
1.8.1.2.459.gbcd45b4.dirty

