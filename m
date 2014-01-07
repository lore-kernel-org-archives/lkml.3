Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755605AbaAGIlA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jan 2014 03:41:00 -0500
Received: from hqemgate16.nvidia.com ([216.228.121.65]:11599 "EHLO
	hqemgate16.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751968AbaAGIk6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jan 2014 03:40:58 -0500
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Tue, 07 Jan 2014 00:41:08 -0800
From: Laxman Dewangan <ldewangan@nvidia.com>
To: <swarren@wwwdotorg.org>
CC: <linux@arm.linux.org.uk>, <thierry.reding@gmail.com>,
        <linux-arm-kernel@lists.infradead.org>, <linux-tegra@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, Laxman Dewangan <ldewangan@nvidia.com>
Subject: [PATCH] ARM: config: enable ams AS3722 power reset driver
Date: Tue, 7 Jan 2014 14:09:59 +0530
Message-ID: <1389084000-17033-1-git-send-email-ldewangan@nvidia.com>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ams AS3722 is used as system PMIC for Tegra124 based Venice2.
Enable ams AS3722 power reset driver for enabling power off
system using PMIC.

Signed-off-by: Laxman Dewangan <ldewangan@nvidia.com>
---
 arch/arm/configs/tegra_defconfig |    1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm/configs/tegra_defconfig b/arch/arm/configs/tegra_defconfig
index 5fdc9a0..b17d301 100644
--- a/arch/arm/configs/tegra_defconfig
+++ b/arch/arm/configs/tegra_defconfig
@@ -142,6 +142,7 @@ CONFIG_POWER_SUPPLY=y
 CONFIG_BATTERY_SBS=y
 CONFIG_CHARGER_TPS65090=y
 CONFIG_POWER_RESET=y
+CONFIG_POWER_RESET_AS3722=y
 CONFIG_POWER_RESET_GPIO=y
 CONFIG_SENSORS_LM90=y
 CONFIG_MFD_AS3722=y
-- 
1.7.9.5

