Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752219Ab3IRMqS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Sep 2013 08:46:18 -0400
Received: from hqemgate15.nvidia.com ([216.228.121.64]:1532 "EHLO
	hqemgate15.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751433Ab3IRMqQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Sep 2013 08:46:16 -0400
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Wed, 18 Sep 2013 05:42:55 -0700
From: Laxman Dewangan <ldewangan@nvidia.com>
To: <swarren@wwwdotorg.org>
CC: <rob.herring@calxeda.com>, <mark.rutland@arm.com>, <pawel.moll@arm.com>,
        <devicetree@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-tegra@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Laxman Dewangan <ldewangan@nvidia.com>
Subject: [PATCH 1/2] ARM: tegra: enable PALMAS_PINCTRL config
Date: Wed, 18 Sep 2013 18:37:21 +0530
Message-ID: <1379509642-19227-1-git-send-email-ldewangan@nvidia.com>
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
Reposting as the patch sent earlier was miss the merge date.

 arch/arm/configs/tegra_defconfig |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/arch/arm/configs/tegra_defconfig b/arch/arm/configs/tegra_defconfig
index bb16a04..3be2122 100644
--- a/arch/arm/configs/tegra_defconfig
+++ b/arch/arm/configs/tegra_defconfig
@@ -130,6 +130,7 @@ CONFIG_SPI=y
 CONFIG_SPI_TEGRA114=y
 CONFIG_SPI_TEGRA20_SFLASH=y
 CONFIG_SPI_TEGRA20_SLINK=y
+CONFIG_PINCTRL_PALMAS=y
 CONFIG_GPIO_PCA953X_IRQ=y
 CONFIG_GPIO_PALMAS=y
 CONFIG_GPIO_TPS6586X=y
-- 
1.7.1.1

