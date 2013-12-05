Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755949Ab3LEXbO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Dec 2013 18:31:14 -0500
Received: from mail-gw2-out.broadcom.com ([216.31.210.63]:13743 "EHLO
	mail-gw2-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752359Ab3LEXbM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Dec 2013 18:31:12 -0500
X-IronPort-AV: E=Sophos;i="4.93,836,1378882800"; 
   d="scan'208";a="388801"
From: Tim Kryger <tim.kryger@linaro.org>
To: Christian Daudt <bcm@fixthebug.org>
CC: Tim Kryger <tim.kryger@linaro.org>,
        <bcm-kernel-feedback-list@broadcom.com>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        <patches@linaro.org>
Subject: [RESEND PATCH] ARM: bcm_defconfig: Do not expect appended DTB
Date: Thu, 5 Dec 2013 15:30:55 -0800
Message-ID: <1386286255-4338-1-git-send-email-tim.kryger@linaro.org>
X-Mailer: git-send-email 1.8.0.1
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The bootloaders used with Broadcom mobile SoCs are capable of handling
a device tree separately from the zImage so there is no need for this
option to be enabled.

Signed-off-by: Tim Kryger <tim.kryger@linaro.org>
Reviewed-by: Markus Mayer <markus.mayer@linaro.org>
---
 arch/arm/configs/bcm_defconfig | 1 -
 1 file changed, 1 deletion(-)

diff --git a/arch/arm/configs/bcm_defconfig b/arch/arm/configs/bcm_defconfig
index 6e49310..b152367 100644
--- a/arch/arm/configs/bcm_defconfig
+++ b/arch/arm/configs/bcm_defconfig
@@ -35,7 +35,6 @@ CONFIG_AEABI=y
 # CONFIG_COMPACTION is not set
 CONFIG_ZBOOT_ROM_TEXT=0x0
 CONFIG_ZBOOT_ROM_BSS=0x0
-CONFIG_ARM_APPENDED_DTB=y
 CONFIG_CMDLINE="console=ttyS0,115200n8 mem=128M"
 CONFIG_CPU_IDLE=y
 CONFIG_VFP=y
-- 
1.8.0.1

