Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751763Ab3HUMSU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Aug 2013 08:18:20 -0400
Received: from hqemgate14.nvidia.com ([216.228.121.143]:18543 "EHLO
	hqemgate14.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751457Ab3HUMSS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Aug 2013 08:18:18 -0400
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Wed, 21 Aug 2013 05:16:03 -0700
From: Laxman Dewangan <ldewangan@nvidia.com>
To: <swarren@wwwdotorg.org>
CC: <linux@arm.linux.org.uk>, <linux-arm-kernel@lists.infradead.org>,
        <devicetree@vger.kernel.org>, <linux-tegra@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, Laxman Dewangan <ldewangan@nvidia.com>
Subject: [PATCH 1/2] ARM: tegra: enable PINCTRL_PALMAS config
Date: Wed, 21 Aug 2013 18:04:20 +0530
Message-ID: <1377088461-9499-1-git-send-email-ldewangan@nvidia.com>
X-Mailer: git-send-email 1.7.1.1
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

PALMAS PMIC is used on Dalmore platform. Enable the pincontrol
driver for Palmas to configure pins of Palmas on desired state.

Signed-off-by: Laxman Dewangan <ldewangan@nvidia.com>
---
 arch/arm/configs/tegra_defconfig |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/arch/arm/configs/tegra_defconfig b/arch/arm/configs/tegra_defconfig
index 8c284ff..e5012dc 100644
--- a/arch/arm/configs/tegra_defconfig
+++ b/arch/arm/configs/tegra_defconfig
@@ -128,6 +128,7 @@ CONFIG_SPI=y
 CONFIG_SPI_TEGRA114=y
 CONFIG_SPI_TEGRA20_SFLASH=y
 CONFIG_SPI_TEGRA20_SLINK=y
+CONFIG_PINCTRL_PALMAS=y
 CONFIG_GPIO_PCA953X_IRQ=y
 CONFIG_GPIO_PALMAS=y
 CONFIG_GPIO_TPS6586X=y
-- 
1.7.1.1

