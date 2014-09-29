Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754164AbaI2MFp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Sep 2014 08:05:45 -0400
Received: from mail-pa0-f52.google.com ([209.85.220.52]:50246 "EHLO
	mail-pa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751753AbaI2MFn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Sep 2014 08:05:43 -0400
From: zhang.lyra@gmail.com
To: catalin.marinas@arm.com, gregkh@linuxfoundation.org,
        ijc+devicetree@hellion.org.uk, jslaby@suse.cz, galak@codeaurora.org,
        broonie@linaro.org, mark.rutland@arm.com, m-karicheri2@ti.com,
        pawel.moll@arm.com, artagnon@gmail.com, rrichter@cavium.com,
        robh+dt@kernel.org, will.deacon@arm.com, orsonzhai@gmail.com,
        geng.ren@spreadtrum.com, zhizhou.zhang@spreadtrum.com
Cc: devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org,
        "chunyan.zhang" <chunyan.zhang@spreadtrum.com>
Subject: [PATCH 4/6] arm64: Add support for Spreadtrum's Shark64 SoC in Kconfig and defconfig
Date: Mon, 29 Sep 2014 20:04:51 +0800
Message-Id: <1411992293-7729-5-git-send-email-zhang.lyra@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1411992293-7729-1-git-send-email-zhang.lyra@gmail.com>
References: <1411992293-7729-1-git-send-email-zhang.lyra@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "zhizhou.zhang" <zhizhou.zhang@spreadtrum.com>

Adds support for Spreadtrum's Shark64 SoC in the arm64 Kconfig
and defconfig files.

Signed-off-by: zhizhou.zhang <zhizhou.zhang@spreadtrum.com>
Signed-off-by: chunyan.zhang <chunyan.zhang@spreadtrum.com>
---
 arch/arm64/Kconfig           |    5 +++++
 arch/arm64/configs/defconfig |    1 +
 2 files changed, 6 insertions(+)

diff --git a/arch/arm64/Kconfig b/arch/arm64/Kconfig
index fd4e81a..c8f36ad 100644
--- a/arch/arm64/Kconfig
+++ b/arch/arm64/Kconfig
@@ -149,6 +149,11 @@ config ARCH_XGENE
 	help
 	  This enables support for AppliedMicro X-Gene SOC Family
 
+config ARCH_SHARK64
+	bool "Spreadtrum 64-bit SOC (ARMv8 platform)"
+	help
+	Support for 64 bits Spreadtrum based systems.
+
 endmenu
 
 menu "Bus support"
diff --git a/arch/arm64/configs/defconfig b/arch/arm64/configs/defconfig
index d92ef3c..86bb5e9 100644
--- a/arch/arm64/configs/defconfig
+++ b/arch/arm64/configs/defconfig
@@ -34,6 +34,7 @@ CONFIG_MODULE_UNLOAD=y
 # CONFIG_IOSCHED_DEADLINE is not set
 CONFIG_ARCH_VEXPRESS=y
 CONFIG_ARCH_XGENE=y
+CONFIG_ARCH_SHARK64=y
 CONFIG_SMP=y
 CONFIG_PREEMPT=y
 CONFIG_KSM=y
-- 
1.7.9.5

