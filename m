Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966555AbaFTMDR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jun 2014 08:03:17 -0400
Received: from mail-ig0-f171.google.com ([209.85.213.171]:46127 "EHLO
	mail-ig0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S967213AbaFTMDP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jun 2014 08:03:15 -0400
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: wsa@the-dreams.de, grant.likely@linaro.org, linux-i2c@vger.kernel.org,
        devicetree@vger.kernel.org, linus.walleij@linaro.org,
        Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 1/9] ARM: multi_v7_defconfig: Enable ST's I2C driver
Date: Fri, 20 Jun 2014 13:02:24 +0100
Message-Id: <1403265753-25851-2-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1403265753-25851-1-git-send-email-lee.jones@linaro.org>
References: <1403265753-25851-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 arch/arm/configs/multi_v7_defconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm/configs/multi_v7_defconfig b/arch/arm/configs/multi_v7_defconfig
index 91af0a9..57335e1 100644
--- a/arch/arm/configs/multi_v7_defconfig
+++ b/arch/arm/configs/multi_v7_defconfig
@@ -200,6 +200,7 @@ CONFIG_I2C_EXYNOS5=y
 CONFIG_I2C_MV64XXX=y
 CONFIG_I2C_SIRF=y
 CONFIG_I2C_TEGRA=y
+CONFIG_I2C_ST=y
 CONFIG_SPI=y
 CONFIG_SPI_OMAP24XX=y
 CONFIG_SPI_ORION=y
-- 
1.8.3.2

