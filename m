Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932401Ab3GLAwi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jul 2013 20:52:38 -0400
Received: from mail-wi0-f179.google.com ([209.85.212.179]:39704 "EHLO
	mail-wi0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932209Ab3GLAwh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jul 2013 20:52:37 -0400
From: Grant Likely <grant.likely@linaro.org>
To: linux-kernel@vger.kernel.org, devicetree-discuss@lists.ozlabs.org,
        spi-devel-general@lists.sourceforge.net
Cc: Grant Likely <grant.likely@linaro.org>
Subject: [PATCH] MAINTAINERS: Remove Grant Likely
Date: Fri, 12 Jul 2013 01:52:16 +0100
Message-Id: <1373590336-14560-1-git-send-email-grant.likely@linaro.org>
X-Mailer: git-send-email 1.8.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Unfortunately, I'm no longer to spend the time needed on maintainership.
It is time for me to step aside and pass maintainership to other
engineers. I'm not disappearing from Linux development, but it would be
irresponsible for me to hold onto a job that I am unable to do.

GPIO and SPI are in good hands with Linus and Mark. Rob Herring has a
really good grasp on the DT core code, and in the last week there have
been several volunteers to create and maintain a DT bindings tree. You
can expect to see an email about that hit the list shortly.

Signed-off-by: Grant Likely <grant.likely@linaro.org>
---
 MAINTAINERS | 8 --------
 1 file changed, 8 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 250dc97..339fcdd 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -3564,10 +3564,8 @@ F:	drivers/isdn/gigaset/
 F:	include/uapi/linux/gigaset_dev.h
 
 GPIO SUBSYSTEM
-M:	Grant Likely <grant.likely@linaro.org>
 M:	Linus Walleij <linus.walleij@linaro.org>
 S:	Maintained
-T:	git git://git.secretlab.ca/git/linux-2.6.git
 F:	Documentation/gpio.txt
 F:	drivers/gpio/
 F:	include/linux/gpio*
@@ -4411,8 +4409,6 @@ F:	drivers/irqchip/
 
 IRQ DOMAINS (IRQ NUMBER MAPPING LIBRARY)
 M:	Benjamin Herrenschmidt <benh@kernel.crashing.org>
-M:	Grant Likely <grant.likely@linaro.org>
-T:	git git://git.secretlab.ca/git/linux-2.6.git irqdomain/next
 S:	Maintained
 F:	Documentation/IRQ-domain.txt
 F:	include/linux/irqdomain.h
@@ -5945,11 +5941,8 @@ F:	Documentation/i2c/busses/i2c-ocores
 F:	drivers/i2c/busses/i2c-ocores.c
 
 OPEN FIRMWARE AND FLATTENED DEVICE TREE
-M:	Grant Likely <grant.likely@linaro.org>
 M:	Rob Herring <rob.herring@calxeda.com>
 L:	devicetree-discuss@lists.ozlabs.org (moderated for non-subscribers)
-W:	http://fdt.secretlab.ca
-T:	git git://git.secretlab.ca/git/linux-2.6.git
 S:	Maintained
 F:	Documentation/devicetree
 F:	drivers/of
@@ -7623,7 +7616,6 @@ F:	drivers/clk/spear/
 
 SPI SUBSYSTEM
 M:	Mark Brown <broonie@kernel.org>
-M:	Grant Likely <grant.likely@linaro.org>
 L:	spi-devel-general@lists.sourceforge.net
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/broonie/spi.git
 Q:	http://patchwork.kernel.org/project/spi-devel-general/list/
-- 
1.8.1.2

