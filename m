Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758108AbaGCNrZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2014 09:47:25 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:56030 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758195AbaGCNrV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2014 09:47:21 -0400
From: Keerthy <j-keerthy@ti.com>
To: <devicetree@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-omap@vger.kernel.org>
CC: <mark.rutland@arm.com>, <galak@codeaurora.org>, <robh+dt@kernel.org>,
        <linux@arm.linux.org.uk>, <balbi@ti.com>, <tony@atomide.com>,
        <kishon@ti.com>, Keerthy <j-keerthy@ti.com>
Subject: [PATCH 5/5] ARM: configs: omap2plus_defconfig: enable TPS65218 configs
Date: Thu, 3 Jul 2014 19:15:02 +0530
Message-ID: <1404395102-21469-6-git-send-email-j-keerthy@ti.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1404395102-21469-1-git-send-email-j-keerthy@ti.com>
References: <1404395102-21469-1-git-send-email-j-keerthy@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Enable TPS65218 config options.

Signed-off-by: Keerthy <j-keerthy@ti.com>
---
 arch/arm/configs/omap2plus_defconfig |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/arm/configs/omap2plus_defconfig b/arch/arm/configs/omap2plus_defconfig
index 536a137..f650f00 100644
--- a/arch/arm/configs/omap2plus_defconfig
+++ b/arch/arm/configs/omap2plus_defconfig
@@ -180,6 +180,7 @@ CONFIG_TWL4030_WATCHDOG=y
 CONFIG_MFD_SYSCON=y
 CONFIG_MFD_PALMAS=y
 CONFIG_MFD_TPS65217=y
+CONFIG_MFD_TPS65218=y
 CONFIG_MFD_TPS65910=y
 CONFIG_TWL6040_CORE=y
 CONFIG_REGULATOR_FIXED_VOLTAGE=y
@@ -188,6 +189,7 @@ CONFIG_REGULATOR_TI_ABB=y
 CONFIG_REGULATOR_TPS65023=y
 CONFIG_REGULATOR_TPS6507X=y
 CONFIG_REGULATOR_TPS65217=y
+CONFIG_REGULATOR_TPS65218=y
 CONFIG_REGULATOR_TPS65910=y
 CONFIG_REGULATOR_TWL4030=y
 CONFIG_REGULATOR_PBIAS=y
-- 
1.7.9.5

