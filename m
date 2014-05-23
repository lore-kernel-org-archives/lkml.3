Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753125AbaEWKcu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 May 2014 06:32:50 -0400
Received: from mail-wg0-f42.google.com ([74.125.82.42]:44920 "EHLO
	mail-wg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753078AbaEWKcr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 May 2014 06:32:47 -0400
From: Daniel Lezcano <daniel.lezcano@linaro.org>
To: tglx@linutronix.de, mingo@kernel.org
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: [PATCH 56/71] KConfig: Vexpress: build the ARM_GLOBAL_TIMER with vexpress platform
Date: Fri, 23 May 2014 12:31:36 +0200
Message-Id: <1400841111-6683-56-git-send-email-daniel.lezcano@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1400841111-6683-1-git-send-email-daniel.lezcano@linaro.org>
References: <537F214C.8000700@linaro.org>
 <1400841111-6683-1-git-send-email-daniel.lezcano@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Matthew Leach <matthew.leach@arm.com>

The Cortex A5 now contains bindings for the global timer
driver. Ensure that the driver is built with a vexpress platform.

Signed-off-by: Matthew Leach <matthew.leach@arm.com>
Signed-off-by: Daniel Lezcano <daniel.lezcano@linaro.org>
---
 arch/arm/mach-vexpress/Kconfig |    1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm/mach-vexpress/Kconfig b/arch/arm/mach-vexpress/Kconfig
index 657d52d..e9811a0 100644
--- a/arch/arm/mach-vexpress/Kconfig
+++ b/arch/arm/mach-vexpress/Kconfig
@@ -4,6 +4,7 @@ config ARCH_VEXPRESS
 	select ARCH_SUPPORTS_BIG_ENDIAN
 	select ARM_AMBA
 	select ARM_GIC
+	select ARM_GLOBAL_TIMER
 	select ARM_TIMER_SP804
 	select COMMON_CLK_VERSATILE
 	select HAVE_ARM_SCU if SMP
-- 
1.7.9.5

