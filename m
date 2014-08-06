Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756547AbaHFShQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Aug 2014 14:37:16 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:42061 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756518AbaHFShO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Aug 2014 14:37:14 -0400
From: Kumar Gala <galak@codeaurora.org>
To: Kumar Gala <galak@codeaurora.org>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-arm-msm@vger.kernel.org
Subject: [PATCH] ARM: qcom: Update defconfig
Date: Wed,  6 Aug 2014 13:37:11 -0500
Message-Id: <1407350231-16902-1-git-send-email-galak@codeaurora.org>
X-Mailer: git-send-email 1.8.2.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Enable IPQ806x & APQ8084 clk support
* Enable CPU_IDLE to get basic wfi support
* Enable SPI NOR and MTD M25P80 support (used on AP148 board)

Signed-off-by: Kumar Gala <galak@codeaurora.org>
---
 arch/arm/configs/qcom_defconfig | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/arch/arm/configs/qcom_defconfig b/arch/arm/configs/qcom_defconfig
index 42ebd72..457f7f0 100644
--- a/arch/arm/configs/qcom_defconfig
+++ b/arch/arm/configs/qcom_defconfig
@@ -29,6 +29,7 @@ CONFIG_HIGHPTE=y
 CONFIG_CLEANCACHE=y
 CONFIG_ARM_APPENDED_DTB=y
 CONFIG_ARM_ATAG_DTB_COMPAT=y
+CONFIG_CPU_IDLE=y
 CONFIG_VFP=y
 CONFIG_NEON=y
 # CONFIG_CORE_DUMP_DEFAULT_ELF_HEADERS is not set
@@ -53,6 +54,7 @@ CONFIG_DEVTMPFS_MOUNT=y
 CONFIG_MTD=y
 CONFIG_MTD_BLOCK=y
 CONFIG_MTD_M25P80=y
+CONFIG_MTD_SPI_NOR=y
 CONFIG_BLK_DEV_LOOP=y
 CONFIG_BLK_DEV_RAM=y
 CONFIG_SCSI=y
@@ -86,7 +88,6 @@ CONFIG_SERIO_LIBPS2=y
 CONFIG_SERIAL_MSM=y
 CONFIG_SERIAL_MSM_CONSOLE=y
 CONFIG_HW_RANDOM=y
-CONFIG_HW_RANDOM_MSM=y
 CONFIG_I2C=y
 CONFIG_I2C_CHARDEV=y
 CONFIG_I2C_QUP=y
@@ -133,6 +134,8 @@ CONFIG_QCOM_BAM_DMA=y
 CONFIG_STAGING=y
 CONFIG_QCOM_GSBI=y
 CONFIG_COMMON_CLK_QCOM=y
+CONFIG_APQ_MMCC_8084=y
+CONFIG_IPQ_GCC_806X=y
 CONFIG_MSM_GCC_8660=y
 CONFIG_MSM_MMCC_8960=y
 CONFIG_MSM_MMCC_8974=y
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
hosted by The Linux Foundation

