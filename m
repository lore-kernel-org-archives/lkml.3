Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935900Ab3DPKnp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Apr 2013 06:43:45 -0400
Received: from mail-wg0-f43.google.com ([74.125.82.43]:65281 "EHLO
	mail-wg0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934017Ab3DPKnn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Apr 2013 06:43:43 -0400
From: grant.likely@linaro.org
To: linux-kernel@vger.kernel.org
Cc: Grant Likely <grant.likely@secretlab.ca>,
        Grant Likely <grant.likely@linaro.org>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>
Subject: [PATCH] MAINTAINERS: Update Grant's email address and maintainership
Date: Tue, 16 Apr 2013 11:43:36 +0100
Message-Id: <1366109016-27442-1-git-send-email-grant.likely@linaro.org>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Grant Likely <grant.likely@secretlab.ca>

I've taken a full time position with Linaro and so I'll be using my
Linaro email address from this point on. It has also been many years
since I've touched any of the Xilinx related code so mark those items as
unmaintained.

In addition, Mark Brown is taking the lead on SPI maintainership now, so
I've reversed the order of our names for that entry.

Signed-off-by: Grant Likely <grant.likely@linaro.org>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Linus Walleij <linus.walleij@linaro.org>
Cc: Rob Herring <rob.herring@calxeda.com>
---
 MAINTAINERS |   18 ++++++------------
 1 file changed, 6 insertions(+), 12 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 9561658..a3be666 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -3502,7 +3502,7 @@ F:	drivers/isdn/gigaset/
 F:	include/uapi/linux/gigaset_dev.h
 
 GPIO SUBSYSTEM
-M:	Grant Likely <grant.likely@secretlab.ca>
+M:	Grant Likely <grant.likely@linaro.org>
 M:	Linus Walleij <linus.walleij@linaro.org>
 S:	Maintained
 T:	git git://git.secretlab.ca/git/linux-2.6.git
@@ -4319,7 +4319,7 @@ F:	drivers/irqchip/
 
 IRQ DOMAINS (IRQ NUMBER MAPPING LIBRARY)
 M:	Benjamin Herrenschmidt <benh@kernel.crashing.org>
-M:	Grant Likely <grant.likely@secretlab.ca>
+M:	Grant Likely <grant.likely@linaro.org>
 T:	git git://git.secretlab.ca/git/linux-2.6.git irqdomain/next
 S:	Maintained
 F:	Documentation/IRQ-domain.txt
@@ -4806,11 +4806,8 @@ F:	arch/powerpc/platforms/40x/
 F:	arch/powerpc/platforms/44x/
 
 LINUX FOR POWERPC EMBEDDED XILINX VIRTEX
-M:	Grant Likely <grant.likely@secretlab.ca>
-W:	http://wiki.secretlab.ca/index.php/Linux_on_Xilinx_Virtex
 L:	linuxppc-dev@lists.ozlabs.org
-T:	git git://git.secretlab.ca/git/linux-2.6.git
-S:	Maintained
+S:	Unmaintained
 F:	arch/powerpc/*/*virtex*
 F:	arch/powerpc/*/*/*virtex*
 
@@ -5798,7 +5795,7 @@ F:	Documentation/i2c/busses/i2c-ocores
 F:	drivers/i2c/busses/i2c-ocores.c
 
 OPEN FIRMWARE AND FLATTENED DEVICE TREE
-M:	Grant Likely <grant.likely@secretlab.ca>
+M:	Grant Likely <grant.likely@linaro.org>
 M:	Rob Herring <rob.herring@calxeda.com>
 L:	devicetree-discuss@lists.ozlabs.org (moderated for non-subscribers)
 W:	http://fdt.secretlab.ca
@@ -7434,11 +7431,10 @@ S:	Maintained
 F:	drivers/clk/spear/
 
 SPI SUBSYSTEM
-M:	Grant Likely <grant.likely@secretlab.ca>
 M:	Mark Brown <broonie@opensource.wolfsonmicro.com>
+M:	Grant Likely <grant.likely@linaro.org>
 L:	spi-devel-general@lists.sourceforge.net
 Q:	http://patchwork.kernel.org/project/spi-devel-general/list/
-T:	git git://git.secretlab.ca/git/linux-2.6.git
 S:	Maintained
 F:	Documentation/spi/
 F:	drivers/spi/
@@ -8942,9 +8938,7 @@ S:	Maintained
 F:	drivers/net/ethernet/xilinx/xilinx_axienet*
 
 XILINX SYSTEMACE DRIVER
-M:	Grant Likely <grant.likely@secretlab.ca>
-W:	http://www.secretlab.ca/
-S:	Maintained
+S:	Unmaintained
 F:	drivers/block/xsysace.c
 
 XILINX UARTLITE SERIAL DRIVER
-- 
1.7.10.4

