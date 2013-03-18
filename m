Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753857Ab3CRLBN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Mar 2013 07:01:13 -0400
Received: from mail-bk0-f54.google.com ([209.85.214.54]:37055 "EHLO
	mail-bk0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752471Ab3CRLBL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Mar 2013 07:01:11 -0400
From: Fabio Baltieri <fabio.baltieri@linaro.org>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Fabio Baltieri <fabio.baltieri@linaro.org>
Subject: [PATCH] ARM: ux500: select WATCHDOG and MUSB for ux500
Date: Mon, 18 Mar 2013 12:00:57 +0100
Message-Id: <1363604457-17112-1-git-send-email-fabio.baltieri@linaro.org>
X-Mailer: git-send-email 1.8.1.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Enable ux500 specific USB and watchdog drivers by default on
u8500_defconfig.

Signed-off-by: Fabio Baltieri <fabio.baltieri@linaro.org>
---

Hello Linus,

ux500 watchdog support was introduced during this merge window and USB
was fixed too, so I'm sending a defconfig update to enable those two
drivers by default, so that those get some more testing.

Thanks,
Fabio

 arch/arm/configs/u8500_defconfig | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/arch/arm/configs/u8500_defconfig b/arch/arm/configs/u8500_defconfig
index 426270f..92b1347 100644
--- a/arch/arm/configs/u8500_defconfig
+++ b/arch/arm/configs/u8500_defconfig
@@ -71,6 +71,7 @@ CONFIG_GPIO_TC3589X=y
 # CONFIG_AB8500_BATTERY_THERM_ON_BATCTRL is not set
 CONFIG_THERMAL=y
 CONFIG_CPU_THERMAL=y
+CONFIG_WATCHDOG=y
 CONFIG_MFD_STMPE=y
 CONFIG_MFD_TC3589X=y
 CONFIG_AB5500_CORE=y
@@ -80,7 +81,12 @@ CONFIG_REGULATOR_AB8500=y
 CONFIG_REGULATOR_FIXED_VOLTAGE=y
 CONFIG_REGULATOR_GPIO=y
 # CONFIG_HID_SUPPORT is not set
+CONFIG_USB=y
+CONFIG_USB_MUSB_HDRC=y
+CONFIG_USB_MUSB_UX500=y
 CONFIG_USB_GADGET=y
+CONFIG_USB_GADGET_MUSB_HDRC=y
+CONFIG_USB_ETH=m
 CONFIG_AB8500_USB=y
 CONFIG_MMC=y
 CONFIG_MMC_CLKGATE=y
-- 
1.8.1.3

