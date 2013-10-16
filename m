Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762121Ab3JPU4Z (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Oct 2013 16:56:25 -0400
Received: from mms1.broadcom.com ([216.31.210.17]:1085 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762022Ab3JPU4Y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Oct 2013 16:56:24 -0400
X-Server-Uuid: 06151B78-6688-425E-9DE2-57CB27892261
From: "Tim Kryger" <tim.kryger@linaro.org>
To: "Christian Daudt" <bcm@fixthebug.org>
cc: "Tim Kryger" <tim.kryger@linaro.org>,
        bcm-kernel-feedback-list@broadcom.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        patches@linaro.org
Subject: [PATCH] ARM: bcm_defconfig: Do not expect appended DTB
Date: Wed, 16 Oct 2013 13:55:30 -0700
Message-ID: <1381956930-1108-1-git-send-email-tim.kryger@linaro.org>
X-Mailer: git-send-email 1.8.0.1
MIME-Version: 1.0
X-WSS-ID: 7E4022E34FK2347813-01-01
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
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


