Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752709Ab3LTTjR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Dec 2013 14:39:17 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:49714 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751024Ab3LTTjQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Dec 2013 14:39:16 -0500
From: =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: arm@kernel.org, Mike Turquette <mturquette@linaro.org>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>, Mark Brown <broonie@kernel.org>,
        Grant Likely <grant.likely@linaro.org>, Rob Herring <robh@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>, kernel@pengutronix.de
Subject: [PATCH] MAINTAINERS: take maintainership for Energy Micro efm32 SoCs
Date: Fri, 20 Dec 2013 20:39:03 +0100
Message-Id: <1387568343-8754-1-git-send-email-u.kleine-koenig@pengutronix.de>
X-Mailer: git-send-email 1.8.5.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:21e:67ff:fe11:9c5c
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
---
Hello,

I think this can best go in via armsoc, but needs acks for clk, clocksource,
spi and tty/serial.

Best regards
Uwe

 MAINTAINERS | 15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index 95648eb..28c69a6 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -867,6 +867,21 @@ S:	Maintained
 F:	arch/arm/mach-ebsa110/
 F:	drivers/net/ethernet/amd/am79c961a.*
 
+ARM/ENERGY MICRO (SILICON LABS) EFM32 SUPPORT
+M:	Uwe Kleine-König <kernel@pengutronix.de>
+L:	linux-arm-kernel@lists.infradead.org (moderated for non-subscribers)
+S:	Maintained
+F:	arch/arm/boot/dts/efm32*
+F:	arch/arm/configs/efm32_defconfig
+F:	arch/arm/include/debug/efm32.S
+F:	arch/arm/mach-efm32/
+F:	drivers/clk/clk-efm32gg.c
+F:	drivers/clocksource/time-efm32.c
+F:	drivers/spi/spi-efm32.c
+F:	drivers/tty/serial/efm32-uart.c
+F:	include/dt-bindings/clock/efm32-cmu.h
+F:	include/linux/platform_data/efm32-*
+
 ARM/EZX SMARTPHONES (A780, A910, A1200, E680, ROKR E2 and ROKR E6)
 M:	Daniel Ribeiro <drwyrm@gmail.com>
 M:	Stefan Schmidt <stefan@openezx.org>
-- 
1.8.5.1

