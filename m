Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754904AbaEGDAS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2014 23:00:18 -0400
Received: from top.free-electrons.com ([176.31.233.9]:55910 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752051AbaEGDAO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2014 23:00:14 -0400
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: Arnd Bergmann <arnd@arndb.de>, wim@iguana.be, dbaryshkov@gmail.com,
        dwmw2@infradead.org
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-watchdog@vger.kernel.org, linux-sunxi@googlegroups.com,
        linux@roeck-us.net, Maxime Ripard <maxime.ripard@free-electrons.com>
Subject: [PATCH v2 5/6] ARM: sunxi: Add A31 reset driver to sunxi_defconfig
Date: Tue,  6 May 2014 21:44:23 -0500
Message-Id: <1399430664-29091-6-git-send-email-maxime.ripard@free-electrons.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1399430664-29091-1-git-send-email-maxime.ripard@free-electrons.com>
References: <1399430664-29091-1-git-send-email-maxime.ripard@free-electrons.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now that the A31 reset code is a driver of its own, we need it in the
defconfig.

Signed-off-by: Maxime Ripard <maxime.ripard@free-electrons.com>
---
 arch/arm/configs/sunxi_defconfig | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/arch/arm/configs/sunxi_defconfig b/arch/arm/configs/sunxi_defconfig
index 81ba78eaf54a..e0c91b23fde7 100644
--- a/arch/arm/configs/sunxi_defconfig
+++ b/arch/arm/configs/sunxi_defconfig
@@ -52,6 +52,9 @@ CONFIG_I2C_MV64XXX=y
 CONFIG_SPI=y
 CONFIG_SPI_SUN6I=y
 CONFIG_GPIO_SYSFS=y
+CONFIG_POWER_SUPPLY=y
+CONFIG_POWER_RESET=y
+CONFIG_POWER_RESET_SUN6I=y
 # CONFIG_HWMON is not set
 CONFIG_WATCHDOG=y
 CONFIG_SUNXI_WATCHDOG=y
-- 
1.9.1

