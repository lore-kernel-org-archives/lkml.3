Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759819AbaGCWIT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2014 18:08:19 -0400
Received: from smtprelay0031.hostedemail.com ([216.40.44.31]:33740 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1759785AbaGCWIQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2014 18:08:16 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::,RULES_HIT:41:355:379:541:800:960:973:988:989:1260:1345:1359:1534:1539:1566:1711:1714:1730:1747:1777:1792:2393:2559:2562:3138:3139:3140:3141:3142:3876:3877:4321:5007:6114:6261:6642:10004:10026:10848:11026:11232:11657:11658:11914:12043:12517:12519:12555:13311:13357:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: sand60_2ac8e84d09304
X-Filterd-Recvd-Size: 1396
From: Joe Perches <joe@perches.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Christian Daudt <csd@broadcom.com>, linux-kernel@vger.kernel.org
Subject: [PATCH 06/16] MAINTAINERS: Use correct filename for sdhci-bcm-kona
Date: Thu,  3 Jul 2014 15:07:50 -0700
Message-Id: <4efb666a0a05ce4934773ccfd4252cd6e211e0dd.1404425176.git.joe@perches.com>
X-Mailer: git-send-email 1.8.1.2.459.gbcd45b4.dirty
In-Reply-To: <cover.1404425176.git.joe@perches.com>
References: <cover.1404425176.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use dashes not underscores.

Signed-off-by: Joe Perches <joe@perches.com>
cc: Christian Daudt <csd@broadcom.com>
---
 MAINTAINERS | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 6d1fc20..0dab840 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -1934,7 +1934,7 @@ F:	arch/arm/boot/dts/bcm113*
 F:	arch/arm/boot/dts/bcm216*
 F:	arch/arm/boot/dts/bcm281*
 F:	arch/arm/configs/bcm_defconfig
-F:	drivers/mmc/host/sdhci_bcm_kona.c
+F:	drivers/mmc/host/sdhci-bcm-kona.c
 F:	drivers/clocksource/bcm_kona_timer.c
 
 BROADCOM BCM2835 ARM ARCHICTURE
-- 
1.8.1.2.459.gbcd45b4.dirty

