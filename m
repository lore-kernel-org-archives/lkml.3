Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760028AbaGCWMD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2014 18:12:03 -0400
Received: from smtprelay0247.hostedemail.com ([216.40.44.247]:39325 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1759718AbaGCWIL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2014 18:08:11 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::,RULES_HIT:41:355:379:541:800:960:973:988:989:1260:1345:1359:1437:1534:1539:1567:1711:1714:1730:1747:1777:1792:2393:2559:2562:2895:3138:3139:3140:3141:3142:3865:3867:3868:4321:5007:6261:10004:10026:10848:11232:11657:11658:11914:12043:12517:12519:12555:13311:13357:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: plane94_2a37490f18b5e
X-Filterd-Recvd-Size: 1529
From: Joe Perches <joe@perches.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Barry Song <Baohua.Song@csr.com>, linux-kernel@vger.kernel.org
Subject: [PATCH 04/16] MAINTAINERS: Update clk/sirf patterns
Date: Thu,  3 Jul 2014 15:07:48 -0700
Message-Id: <32eedc96dfe8761925d0663e50cd29aaac32e9af.1404425176.git.joe@perches.com>
X-Mailer: git-send-email 1.8.1.2.459.gbcd45b4.dirty
In-Reply-To: <cover.1404425176.git.joe@perches.com>
References: <cover.1404425176.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

commit 7bf21bc81f28 ("clk: sirf: re-arch to make the codes support
both prima2 and atlas6") moved the files, update the patterns.

Signed-off-by: Joe Perches <joe@perches.com>
cc: Barry Song <Baohua.Song@csr.com>
---
 MAINTAINERS | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index e3531a5..90ee3d6 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -894,7 +894,7 @@ L:	linux-arm-kernel@lists.infradead.org (moderated for non-subscribers)
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/baohua/linux.git
 S:	Maintained
 F:	arch/arm/mach-prima2/
-F:	drivers/clk/clk-prima2.c
+F:	drivers/clk/sirf/
 F:	drivers/clocksource/timer-prima2.c
 F:	drivers/clocksource/timer-marco.c
 N:	[^a-z]sirf
-- 
1.8.1.2.459.gbcd45b4.dirty

