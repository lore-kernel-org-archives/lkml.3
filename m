Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752468AbaFVUHI (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jun 2014 16:07:08 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:49378 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752122AbaFVUHG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jun 2014 16:07:06 -0400
From: Santosh Shilimkar <santosh.shilimkar@ti.com>
To: <arm@kernel.org>
CC: <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Arnd Bergmann <arnd@arndb.de>, Olof Johansson <olof@lixom.net>,
        Kevin Hilman <khilman@linaro.org>,
        Mike Turquette <mturquette@linaro.org>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH] MAINTAINERS: Add few more Keystone drivers
Date: Sun, 22 Jun 2014 16:06:22 -0400
Message-ID: <1403467582-7933-1-git-send-email-santosh.shilimkar@ti.com>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Update MAINTAINERS file for recently added reset controller, AEMIF
and clocksource driver for Keystone SOCs.

The EMIF memory controller driver is also added along with AEMIF.

Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Olof Johansson <olof@lixom.net>
Cc: Kevin Hilman <khilman@linaro.org>
Cc: Mike Turquette <mturquette@linaro.org>
Cc: Daniel Lezcano <daniel.lezcano@linaro.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Santosh Shilimkar <santosh.shilimkar@ti.com>
---
 MAINTAINERS |   26 +++++++++++++++++++++++++-
 1 file changed, 25 insertions(+), 1 deletion(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 3f2e171..ae6d967 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -1052,9 +1052,33 @@ M:	Santosh Shilimkar <santosh.shilimkar@ti.com>
 L:	linux-arm-kernel@lists.infradead.org (moderated for non-subscribers)
 S:	Maintained
 F:	arch/arm/mach-keystone/
-F:	drivers/clk/keystone/
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/ssantosh/linux-keystone.git
 
+ARM/TEXAS INSTRUMENT KEYSTONE CLOCK FRAMEWORK
+M:	Santosh Shilimkar <santosh.shilimkar@ti.com>
+L:	linux-kernel@vger.kernel.org
+S:	Maintained
+F:	drivers/clk/keystone/
+
+ARM/TEXAS INSTRUMENT KEYSTONE ClOCKSOURCE
+M:	Santosh Shilimkar <santosh.shilimkar@ti.com>
+L:	linux-arm-kernel@lists.infradead.org (moderated for non-subscribers)
+L:	linux-kernel@vger.kernel.org
+S:	Maintained
+F:	drivers/clocksource/timer-keystone.c
+
+ARM/TEXAS INSTRUMENT KEYSTONE RESET DRIVER
+M:	Santosh Shilimkar <santosh.shilimkar@ti.com>
+L:	linux-kernel@vger.kernel.org
+S:	Maintained
+F:	drivers/power/reset/keystone-reset.c
+
+ARM/TEXAS INSTRUMENT AEMIF/EMIF DRIVERS
+M:	Santosh Shilimkar <santosh.shilimkar@ti.com>
+L:	linux-kernel@vger.kernel.org
+S:	Maintained
+F:	drivers/memory/*emif*
+
 ARM/LOGICPD PXA270 MACHINE SUPPORT
 M:	Lennert Buytenhek <kernel@wantstofly.org>
 L:	linux-arm-kernel@lists.infradead.org (moderated for non-subscribers)
-- 
1.7.9.5

