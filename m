Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754055AbbAJIv6 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Jan 2015 03:51:58 -0500
Received: from mail.kmu-office.ch ([178.209.48.109]:37631 "EHLO
	mail.kmu-office.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751306AbbAJIv5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Jan 2015 03:51:57 -0500
From: Stefan Agner <stefan@agner.ch>
To: arnd@arndb.de
Cc: shawn.guo@linaro.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, stefan@agner.ch
Subject: [PATCH RESEND] MAINTAINERS: add Freescale Vybrid SoC
Date: Sat, 10 Jan 2015 09:51:49 +0100
Message-Id: <1420879909-10970-1-git-send-email-stefan@agner.ch>
X-Mailer: git-send-email 2.2.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add Freescale Vybrid family as a own entry, along with an entry for
the so far orphan Vybrid device tree files. Also add myself as
a designated reviewer.

Acked-by: Shawn Guo <shawn.guo@linaro.org>
Signed-off-by: Stefan Agner <stefan@agner.ch>
---

 MAINTAINERS | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index ddb9ac8..5f706ca 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -1011,6 +1011,16 @@ F:	arch/arm/mach-mxs/
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
2.2.1

