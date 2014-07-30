Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754938AbaG3Diz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2014 23:38:55 -0400
Received: from smtprelay0101.hostedemail.com ([216.40.44.101]:42925 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754663AbaG3Diw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2014 23:38:52 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::::::::::,RULES_HIT:41:355:379:541:800:960:966:973:988:989:1260:1345:1359:1431:1437:1534:1542:1711:1730:1747:1777:1792:2196:2199:2393:2559:2562:2895:3138:3139:3140:3141:3142:3302:3352:3865:4385:5007:6261:7514:7809:9149:10004:10026:10848:11026:11232:11657:11658:11914:12043:12517:12519:12555:12977:14096:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: lace07_4d2c73eb74349
X-Filterd-Recvd-Size: 3382
From: Joe Perches <joe@perches.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Thomas Dahlmann <dahlmann.thomas@arcor.de>,
        Nicolas Ferre <nicolas.ferre@atmel.com>, Li Yang <leoli@freescale.com>,
        Eric Miao <eric.y.miao@gmail.com>,
        Russell King <linux@arm.linux.org.uk>,
        Haojian Zhuang <haojian.zhuang@gmail.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Andrzej Pietrasiewicz <andrzej.p@samsung.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 2/6] MAINTAINERS: Update usb/gadget patterns
Date: Tue, 29 Jul 2014 20:38:40 -0700
Message-Id: <d07bbb44f8c937d7e10a0b7a52689ca59d55b787.1406691397.git.joe@perches.com>
X-Mailer: git-send-email 1.8.1.2.459.gbcd45b4.dirty
In-Reply-To: <cover.1406691397.git.joe@perches.com>
References: <cover.1406691397.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Several commits have moved files around, update the section patterns.

Signed-off-by: Joe Perches <joe@perches.com>
cc: Thomas Dahlmann <dahlmann.thomas@arcor.de>
cc: Nicolas Ferre <nicolas.ferre@atmel.com>
cc: Li Yang <leoli@freescale.com>
cc: Eric Miao <eric.y.miao@gmail.com>
cc: Russell King <linux@arm.linux.org.uk>
cc: Haojian Zhuang <haojian.zhuang@gmail.com>
cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
cc: Andrzej Pietrasiewicz <andrzej.p@samsung.com>
---
 MAINTAINERS | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 66d5894..6033aaf 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -596,7 +596,7 @@ AMD GEODE CS5536 USB DEVICE CONTROLLER DRIVER
 M:	Thomas Dahlmann <dahlmann.thomas@arcor.de>
 L:	linux-geode@lists.infradead.org (moderated for non-subscribers)
 S:	Supported
-F:	drivers/usb/gadget/amd5536udc.*
+F:	drivers/usb/gadget/udc/amd5536udc.*
 
 AMD GEODE PROCESSOR/CHIPSET SUPPORT
 P:	Andres Salomon <dilinger@queued.net>
@@ -1688,7 +1688,7 @@ ATMEL USBA UDC DRIVER
 M:	Nicolas Ferre <nicolas.ferre@atmel.com>
 L:	linux-arm-kernel@lists.infradead.org (moderated for non-subscribers)
 S:	Supported
-F:	drivers/usb/gadget/atmel_usba_udc.*
+F:	drivers/usb/gadget/udc/atmel_usba_udc.*
 
 ATMEL WIRELESS DRIVER
 M:	Simon Kelley <simon@thekelleys.org.uk>
@@ -3798,7 +3798,7 @@ M:	Li Yang <leoli@freescale.com>
 L:	linux-usb@vger.kernel.org
 L:	linuxppc-dev@lists.ozlabs.org
 S:	Maintained
-F:	drivers/usb/gadget/fsl*
+F:	drivers/usb/gadget/udc/fsl*
 
 FREESCALE QUICC ENGINE UCC ETHERNET DRIVER
 M:	Li Yang <leoli@freescale.com>
@@ -7232,7 +7232,7 @@ S:	Maintained
 F:	arch/arm/mach-pxa/
 F:	drivers/pcmcia/pxa2xx*
 F:	drivers/spi/spi-pxa2xx*
-F:	drivers/usb/gadget/pxa2*
+F:	drivers/usb/gadget/udc/pxa2*
 F:	include/sound/pxa2xx-lib.h
 F:	sound/arm/pxa*
 F:	sound/soc/pxa/
@@ -9576,8 +9576,8 @@ USB WEBCAM GADGET
 M:	Laurent Pinchart <laurent.pinchart@ideasonboard.com>
 L:	linux-usb@vger.kernel.org
 S:	Maintained
-F:	drivers/usb/gadget/*uvc*.c
-F:	drivers/usb/gadget/webcam.c
+F:	drivers/usb/gadget/function/*uvc*.c
+F:	drivers/usb/gadget/legacy/webcam.c
 
 USB WIRELESS RNDIS DRIVER (rndis_wlan)
 M:	Jussi Kivilinna <jussi.kivilinna@iki.fi>
-- 
1.8.1.2.459.gbcd45b4.dirty

