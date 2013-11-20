Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754816Ab3KTSYa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Nov 2013 13:24:30 -0500
Received: from mail-ea0-f180.google.com ([209.85.215.180]:63337 "EHLO
	mail-ea0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754081Ab3KTSY2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Nov 2013 13:24:28 -0500
From: Taras Kondratiuk <taras.kondratiuk@linaro.org>
To: Santosh Shilimkar <santosh.shilimkar@ti.com>
Cc: patches@linaro.org, linaro-networking@linaro.org,
        linaro-kernel@lists.linaro.org, Russell King <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH] ARM: keystone: enable big endian support
Date: Wed, 20 Nov 2013 20:24:19 +0200
Message-Id: <1384971859-7748-1-git-send-email-taras.kondratiuk@linaro.org>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Keystone code is big endian compatible,
so mark it as one that supports big endian.

Note this patch just allows to select Big endian build
for ARCH_KEYSTONE, but it does not enable BE by default.

Signed-off-by: Taras Kondratiuk <taras.kondratiuk@linaro.org>
---
Based on Linus' master tip (b4789b8).
Tested on Keystone2 EVM.

arch/arm/mach-keystone/Kconfig |    1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm/mach-keystone/Kconfig b/arch/arm/mach-keystone/Kconfig
index f20c53e..8a9e943 100644
--- a/arch/arm/mach-keystone/Kconfig
+++ b/arch/arm/mach-keystone/Kconfig
@@ -11,6 +11,7 @@ config ARCH_KEYSTONE
 	select ARM_ERRATA_798181 if SMP
 	select COMMON_CLK_KEYSTONE
 	select TI_EDMA
+	select ARCH_SUPPORTS_BIG_ENDIAN
 	help
 	  Support for boards based on the Texas Instruments Keystone family of
 	  SoCs.
-- 
1.7.9.5

