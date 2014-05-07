Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752852AbaEGCxm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2014 22:53:42 -0400
Received: from top.free-electrons.com ([176.31.233.9]:55809 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751368AbaEGCxk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2014 22:53:40 -0400
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: Arnd Bergmann <arnd@arndb.de>, wim@iguana.be, dbaryshkov@gmail.com,
        dwmw2@infradead.org
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-watchdog@vger.kernel.org, linux-sunxi@googlegroups.com,
        linux@roeck-us.net, Maxime Ripard <maxime.ripard@free-electrons.com>
Subject: [PATCH v2 6/6] ARM: multi_v7: Add Allwinner reset drivers to multi_v7_defconfig
Date: Tue,  6 May 2014 21:44:24 -0500
Message-Id: <1399430664-29091-7-git-send-email-maxime.ripard@free-electrons.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1399430664-29091-1-git-send-email-maxime.ripard@free-electrons.com>
References: <1399430664-29091-1-git-send-email-maxime.ripard@free-electrons.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now that the reset code are part of drivers of their own, we need those in the
defconfig.

Signed-off-by: Maxime Ripard <maxime.ripard@free-electrons.com>
---
 arch/arm/configs/multi_v7_defconfig | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/arm/configs/multi_v7_defconfig b/arch/arm/configs/multi_v7_defconfig
index d4e8a47a2f7c..960187ac35e0 100644
--- a/arch/arm/configs/multi_v7_defconfig
+++ b/arch/arm/configs/multi_v7_defconfig
@@ -200,12 +200,14 @@ CONFIG_BATTERY_SBS=y
 CONFIG_CHARGER_TPS65090=y
 CONFIG_POWER_RESET_AS3722=y
 CONFIG_POWER_RESET_GPIO=y
+CONFIG_POWER_RESET_SUN6I=y
 CONFIG_SENSORS_LM90=y
 CONFIG_THERMAL=y
 CONFIG_DOVE_THERMAL=y
 CONFIG_ARMADA_THERMAL=y
 CONFIG_WATCHDOG=y
 CONFIG_ORION_WATCHDOG=y
+CONFIG_SUNXI_WATCHDOG=y
 CONFIG_MFD_AS3722=y
 CONFIG_MFD_CROS_EC=y
 CONFIG_MFD_CROS_EC_SPI=y
-- 
1.9.1

