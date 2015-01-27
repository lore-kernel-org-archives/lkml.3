Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757980AbbA0IOA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2015 03:14:00 -0500
Received: from sci-ig2.spreadtrum.com ([222.66.158.135]:17056 "EHLO
	SHSQR01.spreadtrum.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757758AbbA0INz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2015 03:13:55 -0500
From: Chunyan Zhang <chunyan.zhang@spreadtrum.com>
To: <mark.rutland@arm.com>, <arnd@arndb.de>, <catalin.marinas@arm.com>,
        <will.deacon@arm.com>, <robh+dt@kernel.org>, <pawel.moll@arm.com>,
        <ijc+devicetree@hellion.org.uk>, <galak@codeaurora.org>
CC: <Joel.Schopp@amd.com>, <Thomas.Lendacky@amd.com>,
        <Suravee.Suthikulpanit@amd.com>, <broonie@kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        <devicetree@vger.kernel.org>, <geng.ren@spreadtrum.com>,
        <zhizhou.zhang@spreadtrum.com>, <zhang.lyra@gmail.com>,
        <wei.qiao@spreadtrum.com>, <orsonzhai@gmail.com>
Subject: [PATCH v7 2/2] arm64: Add support for Spreadtrum's Sharkl64 Platform in Kconfig and defconfig
Date: Tue, 27 Jan 2015 16:12:47 +0800
Message-ID: <1422346367-10628-3-git-send-email-chunyan.zhang@spreadtrum.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1422346367-10628-1-git-send-email-chunyan.zhang@spreadtrum.com>
References: <sc9836-dt-v7>
 <1422346367-10628-1-git-send-email-chunyan.zhang@spreadtrum.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.0.67.142]
X-ClientProxiedBy: SHCAS01.spreadtrum.com (10.0.1.201) To
 SHMBX02.spreadtrum.com (10.0.1.204)
X-MAIL: SHSQR01.spreadtrum.com t0R8DSN3073005
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Zhizhou Zhang <zhizhou.zhang@spreadtrum.com>

Adds support for Spreadtrum's SoC Platform in the arm64 Kconfig and
defconfig files.

Signed-off-by: Zhizhou Zhang <zhizhou.zhang@spreadtrum.com>
Signed-off-by: Orson Zhai <orson.zhai@spreadtrum.com>
Signed-off-by: Chunyan Zhang <chunyan.zhang@spreadtrum.com>
---
 arch/arm64/Kconfig           |    5 +++++
 arch/arm64/configs/defconfig |    1 +
 2 files changed, 6 insertions(+)

diff --git a/arch/arm64/Kconfig b/arch/arm64/Kconfig
index b1f9a20..885c1f4 100644
--- a/arch/arm64/Kconfig
+++ b/arch/arm64/Kconfig
@@ -153,6 +153,11 @@ config ARCH_SEATTLE
 	help
 	  This enables support for AMD Seattle SOC Family
 
+config ARCH_SPRD
+	bool "Spreadtrum SoC platform"
+	help
+	  Support for Spreadtrum ARM based SoCs
+
 config ARCH_THUNDER
 	bool "Cavium Inc. Thunder SoC Family"
 	help
diff --git a/arch/arm64/configs/defconfig b/arch/arm64/configs/defconfig
index dd301be..2eb303a 100644
--- a/arch/arm64/configs/defconfig
+++ b/arch/arm64/configs/defconfig
@@ -32,6 +32,7 @@ CONFIG_MODULES=y
 CONFIG_MODULE_UNLOAD=y
 # CONFIG_BLK_DEV_BSG is not set
 # CONFIG_IOSCHED_DEADLINE is not set
+CONFIG_ARCH_SPRD=y
 CONFIG_ARCH_THUNDER=y
 CONFIG_ARCH_VEXPRESS=y
 CONFIG_ARCH_XGENE=y
-- 
1.7.9.5

