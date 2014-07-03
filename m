Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759899AbaGCWIc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2014 18:08:32 -0400
Received: from smtprelay0138.hostedemail.com ([216.40.44.138]:41710 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754073AbaGCWI3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2014 18:08:29 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::,RULES_HIT:41:355:379:541:800:960:968:973:988:989:1260:1345:1359:1437:1534:1538:1566:1711:1714:1730:1747:1777:1792:1981:2194:2199:2393:2559:2562:3138:3139:3140:3141:3142:3865:3872:4419:5007:6261:10004:10026:10848:11232:11657:11658:11914:12043:12517:12519:12555:13311:13357:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: act96_2ccadb5d7a92d
X-Filterd-Recvd-Size: 1333
From: Joe Perches <joe@perches.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: James Hogan <james.hogan@imgtec.com>, linux-kernel@vger.kernel.org
Subject: [PATCH 12/16] MAINTAINERS: Remove METAG imgdafs pattern
Date: Thu,  3 Jul 2014 15:07:56 -0700
Message-Id: <ce8a84fb71e9eaaf832ca7f9674bd0e6b4a54daf.1404425176.git.joe@perches.com>
X-Mailer: git-send-email 1.8.1.2.459.gbcd45b4.dirty
In-Reply-To: <cover.1404425176.git.joe@perches.com>
References: <cover.1404425176.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This never made it into the kernel tree.
Remove it.

Signed-off-by: Joe Perches <joe@perches.com>
cc: James Hogan <james.hogan@imgtec.com>
---
 MAINTAINERS | 1 -
 1 file changed, 1 deletion(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 0df8ab5..f223d8f 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -5803,7 +5803,6 @@ F:	drivers/clocksource/metag_generic.c
 F:	drivers/irqchip/irq-metag.c
 F:	drivers/irqchip/irq-metag-ext.c
 F:	drivers/tty/metag_da.c
-F:	fs/imgdafs/
 
 MICROBLAZE ARCHITECTURE
 M:	Michal Simek <monstr@monstr.eu>
-- 
1.8.1.2.459.gbcd45b4.dirty

