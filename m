Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754312AbaFDQbd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2014 12:31:33 -0400
Received: from mail-we0-f181.google.com ([74.125.82.181]:46380 "EHLO
	mail-we0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754294AbaFDQb3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2014 12:31:29 -0400
From: Peter Griffin <peter.griffin@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        chris@printf.net, ulf.hansson@linaro.org, maxime.coquelin@st.com,
        patrice.chotard@st.com, srinivas.kandagatla@gmail.com
Cc: peter.griffin@linaro.org, kernel@stlinux.com, linux-mmc@vger.kernel.org,
        devicetree@vger.kernel.org
Subject: [PATCH v3 09/10] ARM: update multi_v7_defconfig for STI
Date: Wed,  4 Jun 2014 17:30:23 +0100
Message-Id: <1401899424-1365-10-git-send-email-peter.griffin@linaro.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1401899424-1365-1-git-send-email-peter.griffin@linaro.org>
References: <1401899424-1365-1-git-send-email-peter.griffin@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch enables SDHCI STI platform driver.

Signed-off-by: Peter Griffin <peter.griffin@linaro.org>
---
 arch/arm/configs/multi_v7_defconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm/configs/multi_v7_defconfig b/arch/arm/configs/multi_v7_defconfig
index d4e8a47..48951fc 100644
--- a/arch/arm/configs/multi_v7_defconfig
+++ b/arch/arm/configs/multi_v7_defconfig
@@ -277,6 +277,7 @@ CONFIG_MMC_SDHCI_TEGRA=y
 CONFIG_MMC_SDHCI_DOVE=y
 CONFIG_MMC_SDHCI_SPEAR=y
 CONFIG_MMC_SDHCI_BCM_KONA=y
+CONFIG_MMC_SDHCI_ST=y
 CONFIG_MMC_OMAP=y
 CONFIG_MMC_OMAP_HS=y
 CONFIG_MMC_MVSDIO=y
-- 
1.9.1

