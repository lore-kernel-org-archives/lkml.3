Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753999AbaLAN2Y (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Dec 2014 08:28:24 -0500
Received: from eusmtp01.atmel.com ([212.144.249.242]:34574 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753598AbaLANZH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Dec 2014 08:25:07 -0500
From: Nicolas Ferre <nicolas.ferre@atmel.com>
To: <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>
CC: Boris BREZILLON <boris.brezillon@free-electrons.com>,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>,
        Ludovic Desroches <ludovic.desroches@atmel.com>,
        Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        Nicolas Ferre <nicolas.ferre@atmel.com>
Subject: [PATCH 3/4] ARM: at91/defconfig: add QT1070 to at91_dt
Date: Mon, 1 Dec 2014 14:24:39 +0100
Message-ID: <7b6024db44caadf536fd12fb18bf67181413ebe8.1417440150.git.nicolas.ferre@atmel.com>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <eb931e7c5534cd949ba61307f0380826e62ceb2c.1417440150.git.nicolas.ferre@atmel.com>
References: <eb931e7c5534cd949ba61307f0380826e62ceb2c.1417440150.git.nicolas.ferre@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As this touch button driver is used on at91sam9x5ek, it's better to enable it.

Signed-off-by: Nicolas Ferre <nicolas.ferre@atmel.com>
---
 arch/arm/configs/at91_dt_defconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm/configs/at91_dt_defconfig b/arch/arm/configs/at91_dt_defconfig
index cb6ec18ce68b..6ccf937a60f2 100644
--- a/arch/arm/configs/at91_dt_defconfig
+++ b/arch/arm/configs/at91_dt_defconfig
@@ -113,6 +113,7 @@ CONFIG_INPUT_MOUSEDEV_SCREEN_Y=272
 CONFIG_INPUT_JOYDEV=y
 CONFIG_INPUT_EVDEV=y
 # CONFIG_KEYBOARD_ATKBD is not set
+CONFIG_KEYBOARD_QT1070=y
 CONFIG_KEYBOARD_GPIO=y
 # CONFIG_INPUT_MOUSE is not set
 CONFIG_INPUT_TOUCHSCREEN=y
-- 
2.1.3

