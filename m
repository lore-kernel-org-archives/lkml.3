Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755376AbaDOSsb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2014 14:48:31 -0400
Received: from mail-ee0-f44.google.com ([74.125.83.44]:52555 "EHLO
	mail-ee0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754411AbaDOSs3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2014 14:48:29 -0400
From: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
To: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Cc: Russell King <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH] ARM: berlin: add CPU_V7 to Marvell Armada 1500-mini (BG2CD)
Date: Tue, 15 Apr 2014 20:48:19 +0200
Message-Id: <1397587699-11023-1-git-send-email-sebastian.hesselbarth@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This selects missing CPU_V7 for ARM Cortex-A9 based Marvell Armada
1500-mini (BG2CD).

Signed-off-by: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
---
Cc: Russell King <linux@arm.linux.org.uk>
Cc: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org
---
 arch/arm/mach-berlin/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm/mach-berlin/Kconfig b/arch/arm/mach-berlin/Kconfig
index d3c5f14dc142..0add8350faf4 100644
--- a/arch/arm/mach-berlin/Kconfig
+++ b/arch/arm/mach-berlin/Kconfig
@@ -18,6 +18,7 @@ config MACH_BERLIN_BG2
 config MACH_BERLIN_BG2CD
 	bool "Marvell Armada 1500-mini (BG2CD)"
 	select CACHE_L2X0
+	select CPU_V7
 	select HAVE_ARM_TWD if SMP
 
 config MACH_BERLIN_BG2Q
-- 
1.9.1

