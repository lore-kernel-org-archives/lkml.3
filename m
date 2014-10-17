Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752323AbaJQKeL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Oct 2014 06:34:11 -0400
Received: from sci-ig2.spreadtrum.com ([222.66.158.135]:25568 "EHLO
	SHSQR01.spreadtrum.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751846AbaJQKd6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Oct 2014 06:33:58 -0400
From: Chunyan Zhang <chunyan.zhang@spreadtrum.com>
To: <catalin.marinas@arm.com>, <gregkh@linuxfoundation.org>,
        <ijc+devicetree@hellion.org.uk>, <jslaby@suse.cz>,
        <galak@codeaurora.org>, <broonie@linaro.org>, <mark.rutland@arm.com>,
        <m-karicheri2@ti.com>, <pawel.moll@arm.com>, <artagnon@gmail.com>,
        <rrichter@cavium.com>, <robh+dt@kernel.org>, <will.deacon@arm.com>,
        <orsonzhai@gmail.com>, <geng.ren@spreadtrum.com>,
        <zhizhou.zhang@spreadtrum.com>
CC: <devicetree@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, <sprdlinux@freelists.org>
Subject: [PATCH v2 4/5] arm64: Add support for Spreadtrum's Sharkl Platform in Kconfig and defconfig
Date: Fri, 17 Oct 2014 17:54:24 +0800
Message-ID: <1413539665-11484-5-git-send-email-chunyan.zhang@spreadtrum.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1413539665-11484-1-git-send-email-chunyan.zhang@spreadtrum.com>
References: <sprd-1017-v2>
 <1413539665-11484-1-git-send-email-chunyan.zhang@spreadtrum.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.0.67.117]
X-ClientProxiedBy: SHCAS02.spreadtrum.com (10.0.1.202) To
 SHMBX01.spreadtrum.com (10.0.1.203)
X-MAIL: SHSQR01.spreadtrum.com s9H9tEnS008610
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Zhizhou Zhang <zhizhou.zhang@spreadtrum.com>

Adds support for Spreadtrum's Sharkl Platform in the arm64 Kconfig
and defconfig files.

Signed-off-by: Zhizhou Zhang <zhizhou.zhang@spreadtrum.com>
Signed-off-by: Chunyan Zhang <chunyan.zhang@spreadtrum.com>
---
 arch/arm64/Kconfig           |    6 ++++++
 arch/arm64/configs/defconfig |    1 +
 2 files changed, 7 insertions(+)

diff --git a/arch/arm64/Kconfig b/arch/arm64/Kconfig
index fd4e81a..eac2e2c 100644
--- a/arch/arm64/Kconfig
+++ b/arch/arm64/Kconfig
@@ -134,6 +134,12 @@ source "kernel/Kconfig.freezer"
 
 menu "Platform selection"
 
+config ARCH_SHARKL
+	bool "Spreadtrum 64-bit SoC Platform"
+	help
+	  Sharkl is a Spreadtrum's SoC Platform which is based
+	  on ARM 64-bit processor.
+
 config ARCH_VEXPRESS
 	bool "ARMv8 software model (Versatile Express)"
 	select ARCH_REQUIRE_GPIOLIB
diff --git a/arch/arm64/configs/defconfig b/arch/arm64/configs/defconfig
index d92ef3c..c62ff98 100644
--- a/arch/arm64/configs/defconfig
+++ b/arch/arm64/configs/defconfig
@@ -32,6 +32,7 @@ CONFIG_MODULES=y
 CONFIG_MODULE_UNLOAD=y
 # CONFIG_BLK_DEV_BSG is not set
 # CONFIG_IOSCHED_DEADLINE is not set
+CONFIG_ARCH_SHARKL=y
 CONFIG_ARCH_VEXPRESS=y
 CONFIG_ARCH_XGENE=y
 CONFIG_SMP=y
-- 
1.7.9.5

