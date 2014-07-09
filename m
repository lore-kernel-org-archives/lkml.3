Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932631AbaGIPIc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2014 11:08:32 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:38528 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755984AbaGIPI0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2014 11:08:26 -0400
From: Peter Griffin <peter.griffin@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        ulf.hansson@linaro.org, chris@printf.net, maxime.coquelin@st.com,
        patrice.chotard@st.com, srinivas.kandagatla@gmail.com
Cc: peter.griffin@linaro.org, lee.jones@linaro.org, linux-mmc@vger.kernel.org,
        devicetree@vger.kernel.org, peppe.cavallaro@st.com
Subject: [PATCH v4 09/10] ARM: update multi_v7_defconfig for STI
Date: Wed,  9 Jul 2014 16:07:40 +0100
Message-Id: <1404918461-25390-10-git-send-email-peter.griffin@linaro.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1404918461-25390-1-git-send-email-peter.griffin@linaro.org>
References: <1404918461-25390-1-git-send-email-peter.griffin@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch enables SDHCI STI platform driver.

Signed-off-by: Peter Griffin <peter.griffin@linaro.org>
---
 arch/arm/configs/multi_v7_defconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm/configs/multi_v7_defconfig b/arch/arm/configs/multi_v7_defconfig
index 5348364..8c12c4e 100644
--- a/arch/arm/configs/multi_v7_defconfig
+++ b/arch/arm/configs/multi_v7_defconfig
@@ -311,6 +311,7 @@ CONFIG_MMC_SDHCI_SPEAR=y
 CONFIG_MMC_SDHCI_S3C=y
 CONFIG_MMC_SDHCI_S3C_DMA=y
 CONFIG_MMC_SDHCI_BCM_KONA=y
+CONFIG_MMC_SDHCI_ST=y
 CONFIG_MMC_OMAP=y
 CONFIG_MMC_OMAP_HS=y
 CONFIG_MMC_MVSDIO=y
-- 
1.9.1

