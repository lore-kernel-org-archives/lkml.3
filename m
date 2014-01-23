Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756239AbaAWGnL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jan 2014 01:43:11 -0500
Received: from server.prisktech.co.nz ([115.188.14.127]:53778 "EHLO
	server.prisktech.co.nz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756169AbaAWGm6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jan 2014 01:42:58 -0500
From: Tony Prisk <linux@prisktech.co.nz>
To: linux@arm.linux.org.uk
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Tony Prisk <linux@prisktech.co.nz>
Subject: [PATCH] MAINTAINERS: vt8500: Update maintained files for arch/vt8500
Date: Thu, 23 Jan 2014 19:43:21 +1300
Message-Id: <1390459401-30549-1-git-send-email-linux@prisktech.co.nz>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Removed maintainership of the ehci-platform.c and uhci-platform.c
drivers. These drivers are not solely used by arch-vt8500 anymore,
and are captured under Alan Stern's 'USB EHCI DRIVER' and
'USB UHCI DRIVER' wildcards.

Add maintainership for the VT8500's clock, irq and pinctrl drivers
which were added/migrated quite some time ago.

Signed-off-by: Tony Prisk <linux@prisktech.co.nz>
---
 MAINTAINERS |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 6a6e4ac..ac26897 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -1341,14 +1341,15 @@ M:	Tony Prisk <linux@prisktech.co.nz>
 L:	linux-arm-kernel@lists.infradead.org (moderated for non-subscribers)
 S:	Maintained
 F:	arch/arm/mach-vt8500/
+F:	drivers/clk/clk-vt8500.c
 F:	drivers/clocksource/vt8500_timer.c
 F:	drivers/i2c/busses/i2c-wmt.c
+F:	drivers/irqchip/irq-vt8500.c
 F:	drivers/mmc/host/wmt-sdmmc.c
+F:	drivers/pinctrl/vt8500/
 F:	drivers/pwm/pwm-vt8500.c
 F:	drivers/rtc/rtc-vt8500.c
 F:	drivers/tty/serial/vt8500_serial.c
-F:	drivers/usb/host/ehci-platform.c
-F:	drivers/usb/host/uhci-platform.c
 F:	drivers/video/vt8500lcdfb.*
 F:	drivers/video/wm8505fb*
 F:	drivers/video/wmt_ge_rops.*
-- 
1.7.9.5

