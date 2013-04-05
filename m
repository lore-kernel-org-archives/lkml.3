Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964814Ab3DEKMd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Apr 2013 06:12:33 -0400
Received: from cpsmtpb-ews07.kpnxchange.com ([213.75.39.10]:50107 "EHLO
	cpsmtpb-ews07.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932507Ab3DEKMc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Apr 2013 06:12:32 -0400
Message-ID: <1365156749.1830.60.camel@x61.thuisdomein>
Subject: [PATCH] omap2+: Remove useless Makefile line
From: Paul Bolle <pebolle@tiscali.nl>
To: Tony Lindgren <tony@atomide.com>, Russell King <linux@arm.linux.org.uk>
Cc: linux-arm-kernel@lists.infradead.org, linux-omap@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date: Fri, 05 Apr 2013 12:12:29 +0200
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4 (3.4.4-2.fc17) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 05 Apr 2013 10:12:29.0852 (UTC) FILETIME=[149EE5C0:01CE31E6]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit f41caddbe73f52a42f529d668ce47b4d693fd2c0 ("omap2+: Use Kconfig
symbol in Makefile instead of obj-y") reorganized this Makefile. But,
for some reason, it also added references to CONFIG_MACH_ENCORE and
board-omap3encore.o. But there's no Kconfig symbol MACH_ENCORE and
there's no file board-omap3encore.c. This line can safely be removed.

Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
---
 arch/arm/mach-omap2/Makefile | 1 -
 1 file changed, 1 deletion(-)

diff --git a/arch/arm/mach-omap2/Makefile b/arch/arm/mach-omap2/Makefile
index b068b7f..3d0697c 100644
--- a/arch/arm/mach-omap2/Makefile
+++ b/arch/arm/mach-omap2/Makefile
@@ -229,7 +229,6 @@ obj-$(CONFIG_MACH_DEVKIT8000)     	+= board-devkit8000.o
 obj-$(CONFIG_MACH_OMAP_LDP)		+= board-ldp.o
 obj-$(CONFIG_MACH_OMAP3530_LV_SOM)      += board-omap3logic.o
 obj-$(CONFIG_MACH_OMAP3_TORPEDO)        += board-omap3logic.o
-obj-$(CONFIG_MACH_ENCORE)		+= board-omap3encore.o
 obj-$(CONFIG_MACH_OVERO)		+= board-overo.o
 obj-$(CONFIG_MACH_OMAP3EVM)		+= board-omap3evm.o
 obj-$(CONFIG_MACH_OMAP3_PANDORA)	+= board-omap3pandora.o
-- 
1.7.11.7



