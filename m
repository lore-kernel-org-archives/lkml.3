Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759917AbaGCWJy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2014 18:09:54 -0400
Received: from smtprelay0083.hostedemail.com ([216.40.44.83]:59156 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1759855AbaGCWI1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2014 18:08:27 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::,RULES_HIT:41:355:379:541:800:960:968:973:988:989:1260:1345:1359:1437:1534:1540:1568:1711:1714:1730:1747:1777:1792:2393:2559:2562:3138:3139:3140:3141:3142:3865:4039:4321:4699:5007:6261:7809:7904:9592:10004:10026:10848:11232:11658:11914:12043:12517:12519:12555:13255:13311:13357:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: legs78_2c7be6ea94f27
X-Filterd-Recvd-Size: 1717
From: Joe Perches <joe@perches.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: H Hartley Sweeten <hartleys@visionengravers.com>,
        Lennert Buytenhek <kernel@wantstofly.org>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 11/16] MAINTAINERS: Remove section CIRRUS LOGIC EP93XX OHCI USB HOST DRIVER
Date: Thu,  3 Jul 2014 15:07:55 -0700
Message-Id: <b1956b16a28724f3ba5207923a6d7ec26796d964.1404425176.git.joe@perches.com>
X-Mailer: git-send-email 1.8.1.2.459.gbcd45b4.dirty
In-Reply-To: <cover.1404425176.git.joe@perches.com>
References: <cover.1404425176.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

commit e55f7cd24676 ("usb: ohci: remove ep93xx bus glue platform driver")
removed the file, remove the section.

Signed-off-by: Joe Perches <joe@perches.com>
cc: H Hartley Sweeten <hartleys@visionengravers.com>
cc: Lennert Buytenhek <kernel@wantstofly.org>
---
 MAINTAINERS | 6 ------
 1 file changed, 6 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 4749c4f..0df8ab5 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -2276,12 +2276,6 @@ L:	netdev@vger.kernel.org
 S:	Maintained
 F:	drivers/net/ethernet/cirrus/ep93xx_eth.c
 
-CIRRUS LOGIC EP93XX OHCI USB HOST DRIVER
-M:	Lennert Buytenhek <kernel@wantstofly.org>
-L:	linux-usb@vger.kernel.org
-S:	Maintained
-F:	drivers/usb/host/ohci-ep93xx.c
-
 CIRRUS LOGIC AUDIO CODEC DRIVERS
 M:	Brian Austin <brian.austin@cirrus.com>
 M:	Paul Handrigan <Paul.Handrigan@cirrus.com>
-- 
1.8.1.2.459.gbcd45b4.dirty

