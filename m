Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754047Ab3GTMXh (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Jul 2013 08:23:37 -0400
Received: from mail-wi0-f177.google.com ([209.85.212.177]:58941 "EHLO
	mail-wi0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753895Ab3GTMWg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Jul 2013 08:22:36 -0400
From: Grant Likely <grant.likely@linaro.org>
To: linux-kernel@vger.kernel.org
Cc: Grant Likely <grant.likely@linaro.org>,
        Linux Walleij <linus.walleij@linaro.org>,
        Mark Brown <broonie@kernel.org>, Rob Herring <rob.herring@calxeda.com>
Subject: [PATCH 1/3] MAINTAINERS: Remove Grant Likely
Date: Fri, 19 Jul 2013 20:19:46 -0700
Message-Id: <1374290388-19308-1-git-send-email-grant.likely@linaro.org>
X-Mailer: git-send-email 1.8.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Unfortunately, I'm no longer to spend the time needed on maintainership.
It is time for me to step aside and pass maintainership to other
engineers. I'm not disappearing from Linux development, but it would be
irresponsible for me to hold onto a job that I am unable to do.

v2: Leave my name on devicetree core code maintainership. Rob NAKed that
    part of the patch. :)

Signed-off-by: Grant Likely <grant.likely@linaro.org>
Cc: Linux Walleij <linus.walleij@linaro.org>
Cc: Mark Brown <broonie@kernel.org>
Cc: Rob Herring <rob.herring@calxeda.com>
---
 MAINTAINERS | 5 -----
 1 file changed, 5 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index bf61e04..844d7e8 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -3622,11 +3622,9 @@ F:	drivers/isdn/gigaset/
 F:	include/uapi/linux/gigaset_dev.h
 
 GPIO SUBSYSTEM
-M:	Grant Likely <grant.likely@linaro.org>
 M:	Linus Walleij <linus.walleij@linaro.org>
 S:	Maintained
 L:	linux-gpio@vger.kernel.org
-T:	git git://git.secretlab.ca/git/linux-2.6.git
 F:	Documentation/gpio.txt
 F:	drivers/gpio/
 F:	include/linux/gpio*
@@ -4472,8 +4470,6 @@ F:	drivers/irqchip/
 
 IRQ DOMAINS (IRQ NUMBER MAPPING LIBRARY)
 M:	Benjamin Herrenschmidt <benh@kernel.crashing.org>
-M:	Grant Likely <grant.likely@linaro.org>
-T:	git git://git.secretlab.ca/git/linux-2.6.git irqdomain/next
 S:	Maintained
 F:	Documentation/IRQ-domain.txt
 F:	include/linux/irqdomain.h
@@ -7746,7 +7742,6 @@ F:	drivers/clk/spear/
 
 SPI SUBSYSTEM
 M:	Mark Brown <broonie@kernel.org>
-M:	Grant Likely <grant.likely@linaro.org>
 L:	linux-spi@vger.kernel.org
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/broonie/spi.git
 Q:	http://patchwork.kernel.org/project/spi-devel-general/list/
-- 
1.8.1.2

