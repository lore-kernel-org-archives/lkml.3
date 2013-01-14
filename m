Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756591Ab3ANO6L (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jan 2013 09:58:11 -0500
Received: from mail-wi0-f178.google.com ([209.85.212.178]:62319 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756065Ab3ANO6K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jan 2013 09:58:10 -0500
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: arnd@arndb.de, linus.walleij@stericsson.com,
        Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 1/1] ARM: ux500: Disable Power Supply and Battery Management by default
Date: Mon, 14 Jan 2013 14:57:50 +0000
Message-Id: <1358175470-5041-1-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The AB8500 Battery Management collection of drivers are more than a
little bit broken. There is lots of work still on-going in that area
and it's improving day by day; however, it's not ready to be enabled
by default just yet.

Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 arch/arm/configs/u8500_defconfig |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/arm/configs/u8500_defconfig b/arch/arm/configs/u8500_defconfig
index 231dca6..426270f 100644
--- a/arch/arm/configs/u8500_defconfig
+++ b/arch/arm/configs/u8500_defconfig
@@ -66,9 +66,9 @@ CONFIG_SPI=y
 CONFIG_SPI_PL022=y
 CONFIG_GPIO_STMPE=y
 CONFIG_GPIO_TC3589X=y
-CONFIG_POWER_SUPPLY=y
-CONFIG_AB8500_BM=y
-CONFIG_AB8500_BATTERY_THERM_ON_BATCTRL=y
+# CONFIG_POWER_SUPPLY is not set
+# CONFIG_AB8500_BM is not set
+# CONFIG_AB8500_BATTERY_THERM_ON_BATCTRL is not set
 CONFIG_THERMAL=y
 CONFIG_CPU_THERMAL=y
 CONFIG_MFD_STMPE=y
-- 
1.7.9.5

