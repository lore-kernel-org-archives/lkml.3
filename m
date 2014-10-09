Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750967AbaJIIdk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Oct 2014 04:33:40 -0400
Received: from ns.mm-sol.com ([37.157.136.199]:35485 "EHLO extserv.mm-sol.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750918AbaJIIdf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Oct 2014 04:33:35 -0400
From: Georgi Djakov <gdjakov@mm-sol.com>
To: galak@codeaurora.org
Cc: linux@arm.linux.org.uk, sboyd@codeaurora.org, olof@lixom.net,
        khilman@linaro.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        joshc@codeaurora.org, Georgi Djakov <gdjakov@mm-sol.com>
Subject: [PATCH] ARM: qcom: Increase MMC_BLOCK_MINORS in defconfig
Date: Thu,  9 Oct 2014 11:33:34 +0300
Message-Id: <1412843614-4537-1-git-send-email-gdjakov@mm-sol.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There are currently more than 16 partitions on the eMMC of all recent
Qualcomm devices. Increase the number of minors per block device to
detect all available partitions.

Signed-off-by: Georgi Djakov <gdjakov@mm-sol.com>
---
 arch/arm/configs/qcom_defconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/configs/qcom_defconfig b/arch/arm/configs/qcom_defconfig
index 8c7da33..cd09e12 100644
--- a/arch/arm/configs/qcom_defconfig
+++ b/arch/arm/configs/qcom_defconfig
@@ -125,7 +125,7 @@ CONFIG_USB_GADGET=y
 CONFIG_USB_GADGET_DEBUG_FILES=y
 CONFIG_USB_GADGET_VBUS_DRAW=500
 CONFIG_MMC=y
-CONFIG_MMC_BLOCK_MINORS=16
+CONFIG_MMC_BLOCK_MINORS=32
 CONFIG_MMC_ARMMMCI=y
 CONFIG_MMC_SDHCI=y
 CONFIG_MMC_SDHCI_PLTFM=y
-- 
1.7.9.5

