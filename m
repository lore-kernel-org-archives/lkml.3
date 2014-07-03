Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759945AbaGCWKY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2014 18:10:24 -0400
Received: from smtprelay0157.hostedemail.com ([216.40.44.157]:59151 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1759825AbaGCWIX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2014 18:08:23 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::,RULES_HIT:41:355:379:541:800:960:968:973:988:989:1260:1345:1359:1437:1534:1539:1567:1711:1714:1730:1747:1777:1792:2393:2559:2562:3138:3139:3140:3141:3142:3865:3867:3872:4321:5007:6120:6261:7809:7901:10004:10026:10848:11232:11657:11658:11914:12517:12519:12555:13311:13357:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: crowd77_2bbb5bd927316
X-Filterd-Recvd-Size: 1376
From: Joe Perches <joe@perches.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Sangbeom Kim <sbkim73@samsung.com>, linux-kernel@vger.kernel.org
Subject: [PATCH 09/16] MAINTAINERS: Update Samsunt MFD drivers pattern
Date: Thu,  3 Jul 2014 15:07:53 -0700
Message-Id: <169fb51c0d59b216636d48810792f67ecfb5179d.1404425176.git.joe@perches.com>
X-Mailer: git-send-email 1.8.1.2.459.gbcd45b4.dirty
In-Reply-To: <cover.1404425176.git.joe@perches.com>
References: <cover.1404425176.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This rtc/rtc-sec.c file has never been added to the kernel tree.
It's been 2 years.  Remove it.

Signed-off-by: Joe Perches <joe@perches.com>
cc: Sangbeom Kim <sbkim73@samsung.com>
---
 MAINTAINERS | 1 -
 1 file changed, 1 deletion(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index e0f326c..8575e84 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -7722,7 +7722,6 @@ S:	Supported
 F:	drivers/mfd/sec*.c
 F:	drivers/regulator/s2m*.c
 F:	drivers/regulator/s5m*.c
-F:	drivers/rtc/rtc-sec.c
 F:	include/linux/mfd/samsung/
 
 SAMSUNG S5P/EXYNOS4 SOC SERIES CAMERA SUBSYSTEM DRIVERS
-- 
1.8.1.2.459.gbcd45b4.dirty

