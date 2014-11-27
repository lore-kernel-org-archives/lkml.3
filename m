Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751506AbaK0XeF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Nov 2014 18:34:05 -0500
Received: from mail.kmu-office.ch ([178.209.48.109]:54871 "EHLO
	mail.kmu-office.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751082AbaK0XeE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Nov 2014 18:34:04 -0500
From: Stefan Agner <stefan@agner.ch>
To: shawn.guo@linaro.org, arnd@arndb.de
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        stefan@agner.ch
Subject: [PATCH] MAINTAINERS: add Freescale Vybrid SoC
Date: Fri, 28 Nov 2014 00:33:55 +0100
Message-Id: <1417131235-3077-1-git-send-email-stefan@agner.ch>
X-Mailer: git-send-email 2.1.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add Freescale Vybrid family as a own entry, along with an entry for
the so far orphan Vybrid device tree files. Also add myself as
a designated reviewer.

Signed-off-by: Stefan Agner <stefan@agner.ch>
---
Not sure if this is acceptable, but it would be nice when I get Vybrid
related stuff automatically...

 MAINTAINERS | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index 3c64271..6837f23 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -990,6 +990,16 @@ F:	arch/arm/mach-mxs/
 F:	arch/arm/boot/dts/imx*
 F:	arch/arm/configs/imx*_defconfig
 
+ARM/FREESCALE VYBRID ARM ARCHITECTURE
+M:	Shawn Guo <shawn.guo@linaro.org>
+M:	Sascha Hauer <kernel@pengutronix.de>
+R:	Stefan Agner <stefan@agner.ch>
+L:	linux-arm-kernel@lists.infradead.org (moderated for non-subscribers)
+S:	Maintained
+T:	git git://git.kernel.org/pub/scm/linux/kernel/git/shawnguo/linux.git
+F:	arch/arm/mach-imx/*vf610*
+F:	arch/arm/boot/dts/vf*
+
 ARM/GLOMATION GESBC9312SX MACHINE SUPPORT
 M:	Lennert Buytenhek <kernel@wantstofly.org>
 L:	linux-arm-kernel@lists.infradead.org (moderated for non-subscribers)
-- 
2.1.3

