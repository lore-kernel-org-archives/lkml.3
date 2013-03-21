Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757114Ab3CULJ7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Mar 2013 07:09:59 -0400
Received: from mail-we0-f170.google.com ([74.125.82.170]:48904 "EHLO
	mail-we0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757023Ab3CULJ6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Mar 2013 07:09:58 -0400
From: Fabio Baltieri <fabio.baltieri@linaro.org>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Fabio Baltieri <fabio.baltieri@linaro.org>
Subject: [PATCH v2] ARM: ux500: select WATCHDOG and MUSB for ux500
Date: Thu, 21 Mar 2013 12:09:46 +0100
Message-Id: <1363864186-11514-1-git-send-email-fabio.baltieri@linaro.org>
X-Mailer: git-send-email 1.8.1.3
In-Reply-To: <20130319115518.GA1558@balto.lan>
References: <20130319115518.GA1558@balto.lan>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Enable ux500 specific USB and watchdog drivers by default on
u8500_defconfig.

Signed-off-by: Fabio Baltieri <fabio.baltieri@linaro.org>
---

Hi Linus,

this enables USB and watchdog on ux500 defconfig, and is generated
considering the new USB_PHY config option recently added in the
musb-next tree.

Thanks,
Fabio

 arch/arm/configs/u8500_defconfig | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/arch/arm/configs/u8500_defconfig b/arch/arm/configs/u8500_defconfig
index 426270f..a68b773 100644
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
@@ -80,7 +81,14 @@ CONFIG_REGULATOR_AB8500=y
 CONFIG_REGULATOR_FIXED_VOLTAGE=y
 CONFIG_REGULATOR_GPIO=y
 # CONFIG_HID_SUPPORT is not set
+CONFIG_USB=y
+CONFIG_USB_MUSB_HDRC=y
+CONFIG_USB_MUSB_UX500=y
+CONFIG_USB_PHY=y
+CONFIG_AB8500_USB=y
 CONFIG_USB_GADGET=y
+CONFIG_USB_GADGET_MUSB_HDRC=y
+CONFIG_USB_ETH=m
 CONFIG_AB8500_USB=y
 CONFIG_MMC=y
 CONFIG_MMC_CLKGATE=y
-- 
1.8.1.3

