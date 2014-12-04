Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753851AbaLDMCH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2014 07:02:07 -0500
Received: from sci-ig2.spreadtrum.com ([222.66.158.135]:28180 "EHLO
	SHSQR01.spreadtrum.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753666AbaLDMCD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2014 07:02:03 -0500
From: Chunyan Zhang <chunyan.zhang@spreadtrum.com>
To: <gregkh@linuxfoundation.org>, <mark.rutland@arm.com>, <arnd@arndb.de>,
        <gnomes@lxorguk.ukuu.org.uk>, <broonie@kernel.org>,
        <robh+dt@kernel.org>, <pawel.moll@arm.com>,
        <ijc+devicetree@hellion.org.uk>, <galak@codeaurora.org>,
        <will.deacon@arm.com>, <catalin.marinas@arm.com>, <jslaby@suse.cz>,
        <jason@lakedaemon.net>, <heiko@sntech.de>, <florian.vaussard@epfl.ch>,
        <andrew@lunn.ch>, <rrichter@cavium.com>, <hytszk@gmail.com>,
        <grant.likely@linaro.org>, <orsonzhai@gmail.com>,
        <geng.ren@spreadtrum.com>, <zhizhou.zhang@spreadtrum.com>,
        <lanqing.liu@spreadtrum.com>, <zhang.lyra@gmail.com>,
        <wei.qiao@spreadtrum.com>
CC: <devicetree@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, <sprdlinux@freelists.org>,
        <linux-doc@vger.kernel.org>, <linux-serial@vger.kernel.org>,
        <linux-api@vger.kernel.org>, <arm@kernel.org>
Subject: [PATCH v4 4/5] arm64: Add support for Spreadtrum's Sharkl64 Platform in Kconfig and defconfig
Date: Thu, 4 Dec 2014 19:34:19 +0800
Message-ID: <1417692860-18841-5-git-send-email-chunyan.zhang@spreadtrum.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1417692860-18841-1-git-send-email-chunyan.zhang@spreadtrum.com>
References: <sc9836v4>
 <1417692860-18841-1-git-send-email-chunyan.zhang@spreadtrum.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.0.67.89]
X-ClientProxiedBy: SHCAS01.spreadtrum.com (10.0.1.201) To
 SHMBX01.spreadtrum.com (10.0.1.203)
X-MAIL: SHSQR01.spreadtrum.com sB4BZm09009876
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Zhizhou Zhang <zhizhou.zhang@spreadtrum.com>

Adds support for Spreadtrum's SoC Platform in the arm64 Kconfig and
defconfig files.

Signed-off-by: Zhizhou Zhang <zhizhou.zhang@spreadtrum.com>
Signed-off-by: Chunyan Zhang <chunyan.zhang@spreadtrum.com>
Signed-off-by: Orson Zhai <orson.zhai@spreadtrum.com>
---
 arch/arm64/Kconfig           |    6 ++++++
 arch/arm64/configs/defconfig |    1 +
 2 files changed, 7 insertions(+)

diff --git a/arch/arm64/Kconfig b/arch/arm64/Kconfig
index ac9afde..abca2c4 100644
--- a/arch/arm64/Kconfig
+++ b/arch/arm64/Kconfig
@@ -146,6 +146,12 @@ config ARCH_THUNDER
 	help
 	  This enables support for Cavium's Thunder Family of SoCs.
 
+config ARCH_SPRD
+	bool "Spreadtrum SoC platform"
+	depends on ARM64
+	help
+	  Support for Spreadtrum ARM based SoCs
+
 config ARCH_VEXPRESS
 	bool "ARMv8 software model (Versatile Express)"
 	select ARCH_REQUIRE_GPIOLIB
diff --git a/arch/arm64/configs/defconfig b/arch/arm64/configs/defconfig
index 9cd37de..db39340 100644
--- a/arch/arm64/configs/defconfig
+++ b/arch/arm64/configs/defconfig
@@ -33,6 +33,7 @@ CONFIG_MODULE_UNLOAD=y
 # CONFIG_BLK_DEV_BSG is not set
 # CONFIG_IOSCHED_DEADLINE is not set
 CONFIG_ARCH_THUNDER=y
+CONFIG_ARCH_SPRD=y
 CONFIG_ARCH_VEXPRESS=y
 CONFIG_ARCH_XGENE=y
 CONFIG_SMP=y
-- 
1.7.9.5

