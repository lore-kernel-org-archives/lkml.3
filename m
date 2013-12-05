Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752334Ab3LET1K (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Dec 2013 14:27:10 -0500
Received: from qemu.weilnetz.de ([37.221.198.45]:57593 "EHLO
	v2201305906712890.yourvserver.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751190Ab3LET1I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Dec 2013 14:27:08 -0500
X-Greylist: delayed 554 seconds by postgrey-1.27 at vger.kernel.org; Thu, 05 Dec 2013 14:27:08 EST
From: Stefan Weil <sw@weilnetz.de>
To: linux-kernel@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org, linux-rpi-kernel@lists.infradead.org,
        Stefan Weil <sw@weilnetz.de>, Stephen Warren <swarren@wwwdotorg.org>,
        Russell King <linux@arm.linux.org.uk>,
        Jiri Kosina <trivial@kernel.org>
Subject: [PATCH] ARM: bcm2835: Fix grammar in help message
Date: Thu,  5 Dec 2013 20:17:40 +0100
Message-Id: <1386271060-2375-1-git-send-email-sw@weilnetz.de>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Replace "is use" by "is used" and remove a comma.

Cc: Stephen Warren <swarren@wwwdotorg.org>
Cc: Russell King <linux@arm.linux.org.uk>
Cc: Jiri Kosina <trivial@kernel.org>
Signed-off-by: Stefan Weil <sw@weilnetz.de>
---
 arch/arm/mach-bcm2835/Kconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/mach-bcm2835/Kconfig b/arch/arm/mach-bcm2835/Kconfig
index 560045c..d1f9612 100644
--- a/arch/arm/mach-bcm2835/Kconfig
+++ b/arch/arm/mach-bcm2835/Kconfig
@@ -12,4 +12,4 @@ config ARCH_BCM2835
 	select PINCTRL_BCM2835
 	help
 	  This enables support for the Broadcom BCM2835 SoC. This SoC is
-	  use in the Raspberry Pi, and Roku 2 devices.
+	  used in the Raspberry Pi and Roku 2 devices.
-- 
1.7.10.4

