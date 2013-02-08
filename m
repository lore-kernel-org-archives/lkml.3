Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1947144Ab3BHVKn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Feb 2013 16:10:43 -0500
Received: from sauhun.de ([89.238.76.85]:47426 "EHLO pokefinder.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1947070Ab3BHVKl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Feb 2013 16:10:41 -0500
X-Greylist: delayed 2173 seconds by postgrey-1.27 at vger.kernel.org; Fri, 08 Feb 2013 16:10:41 EST
From: Wolfram Sang <wolfram@the-dreams.de>
To: linux-i2c@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Wolfram Sang <wolfram@the-dreams.de>
Subject: [PATCH] MAINTAINERS: change my email and repos
Date: Fri,  8 Feb 2013 21:34:16 +0100
Message-Id: <1360355656-25714-1-git-send-email-wolfram@the-dreams.de>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Change to my private email, change to my shiny new kernel.org repos,
and drop outdated entry from the former maintainer. Drop my PCA entry,
too, since it belongs to the I2C realm anyhow.

Signed-off-by: Wolfram Sang <wolfram@the-dreams.de>
---
 MAINTAINERS |   16 +++-------------
 1 file changed, 3 insertions(+), 13 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 8ae709e..8c13cc8 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -1303,7 +1303,7 @@ F:	include/linux/dmaengine.h
 F:	include/linux/async_tx.h
 
 AT24 EEPROM DRIVER
-M:	Wolfram Sang <w.sang@pengutronix.de>
+M:	Wolfram Sang <wolfram@the-dreams.de>
 L:	linux-i2c@vger.kernel.org
 S:	Maintained
 F:	drivers/misc/eeprom/at24.c
@@ -3757,12 +3757,11 @@ S:	Maintained
 F:	drivers/i2c/i2c-stub.c
 
 I2C SUBSYSTEM
-M:	Wolfram Sang <w.sang@pengutronix.de>
+M:	Wolfram Sang <wolfram@the-dreams.de>
 M:	"Ben Dooks (embedded platforms)" <ben-linux@fluff.org>
 L:	linux-i2c@vger.kernel.org
 W:	http://i2c.wiki.kernel.org/
-T:	quilt kernel.org/pub/linux/kernel/people/jdelvare/linux-2.6/jdelvare-i2c/
-T:	git git://git.pengutronix.de/git/wsa/linux.git
+T:	git git://git.kernel.org/pub/scm/linux/kernel/git/wsa/linux.git
 S:	Maintained
 F:	Documentation/i2c/
 F:	drivers/i2c/
@@ -5778,15 +5777,6 @@ L:	linux-i2c@vger.kernel.org
 S:	Maintained
 F:	drivers/i2c/muxes/i2c-mux-pca9541.c
 
-PCA9564/PCA9665 I2C BUS DRIVER
-M:	Wolfram Sang <w.sang@pengutronix.de>
-L:	linux-i2c@vger.kernel.org
-S:	Maintained
-F:	drivers/i2c/algos/i2c-algo-pca.c
-F:	drivers/i2c/busses/i2c-pca-*
-F:	include/linux/i2c-algo-pca.h
-F:	include/linux/i2c-pca-platform.h
-
 PCDP - PRIMARY CONSOLE AND DEBUG PORT
 M:	Khalid Aziz <khalid@gonehiking.org>
 S:	Maintained
-- 
1.7.10.4

