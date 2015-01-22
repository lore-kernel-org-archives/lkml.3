Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754324AbbAVJvc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2015 04:51:32 -0500
Received: from mail-ie0-f179.google.com ([209.85.223.179]:43509 "EHLO
	mail-ie0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752377AbbAVJtU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2015 04:49:20 -0500
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: lee.jones@linaro.org, kernel@stlinux.com, tglx@linutronix.de,
        jason@lakedaemon.net, devicetree@vger.kernel.org
Subject: [PATCH v2 RESEND 8/8] ARM: STI: Ensure requested STi's SysCfg Controlled IRQs are enabled at boot
Date: Thu, 22 Jan 2015 09:48:53 +0000
Message-Id: <1421920133-7914-9-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1421920133-7914-1-git-send-email-lee.jones@linaro.org>
References: <1421920133-7914-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This driver is used to enable System Configuration Register controlled
External, CTI (Core Sight), PMU (Performance Management), and PL310 L2
Cache IRQs prior to use.

Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 arch/arm/mach-sti/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm/mach-sti/Kconfig b/arch/arm/mach-sti/Kconfig
index 8825bc9..5d8b3f8 100644
--- a/arch/arm/mach-sti/Kconfig
+++ b/arch/arm/mach-sti/Kconfig
@@ -1,6 +1,7 @@
 menuconfig ARCH_STI
 	bool "STMicroelectronics Consumer Electronics SOCs" if ARCH_MULTI_V7
 	select ARM_GIC
+	select ST_IRQCHIP
 	select ARM_GLOBAL_TIMER
 	select PINCTRL
 	select PINCTRL_ST
-- 
1.9.1

