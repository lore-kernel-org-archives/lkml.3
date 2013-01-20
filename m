Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752798Ab3ATC7Y (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Jan 2013 21:59:24 -0500
Received: from mail-we0-f170.google.com ([74.125.82.170]:48454 "EHLO
	mail-we0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752435Ab3ATC7W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Jan 2013 21:59:22 -0500
X-Greylist: delayed 478 seconds by postgrey-1.27 at vger.kernel.org; Sat, 19 Jan 2013 21:59:22 EST
From: =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali.rohar@gmail.com>
To: Tony Lindgren <tony@atomide.com>, Russell King <linux@arm.linux.org.uk>
Cc: linux-arm-kernel@lists.infradead.org, linux-omap@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali.rohar@gmail.com>
Subject: [PATCH] RX-51: Add leds lp5523 names from Maemo 5 2.6.28 kernel
Date: Sun, 20 Jan 2013 03:50:44 +0100
Message-Id: <1358650244-29722-1-git-send-email-pali.rohar@gmail.com>
X-Mailer: git-send-email 1.7.10.4
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Pali Rohár <pali.rohar@gmail.com>
---
 arch/arm/mach-omap2/board-rx51-peripherals.c |    9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/arch/arm/mach-omap2/board-rx51-peripherals.c b/arch/arm/mach-omap2/board-rx51-peripherals.c
index 7611958..9a0dbb7 100644
--- a/arch/arm/mach-omap2/board-rx51-peripherals.c
+++ b/arch/arm/mach-omap2/board-rx51-peripherals.c
@@ -168,30 +168,39 @@ static struct tsl2563_platform_data rx51_tsl2563_platform_data = {
 #if defined(CONFIG_LEDS_LP5523) || defined(CONFIG_LEDS_LP5523_MODULE)
 static struct lp5523_led_config rx51_lp5523_led_config[] = {
 	{
+		.name		= "lp5523:kb1",
 		.chan_nr	= 0,
 		.led_current	= 50,
 	}, {
+		.name		= "lp5523:kb2",
 		.chan_nr	= 1,
 		.led_current	= 50,
 	}, {
+		.name		= "lp5523:kb3",
 		.chan_nr	= 2,
 		.led_current	= 50,
 	}, {
+		.name		= "lp5523:kb4",
 		.chan_nr	= 3,
 		.led_current	= 50,
 	}, {
+		.name		= "lp5523:b",
 		.chan_nr	= 4,
 		.led_current	= 50,
 	}, {
+		.name		= "lp5523:g",
 		.chan_nr	= 5,
 		.led_current	= 50,
 	}, {
+		.name		= "lp5523:r",
 		.chan_nr	= 6,
 		.led_current	= 50,
 	}, {
+		.name		= "lp5523:kb5",
 		.chan_nr	= 7,
 		.led_current	= 50,
 	}, {
+		.name		= "lp5523:kb6",
 		.chan_nr	= 8,
 		.led_current	= 50,
 	}
-- 
1.7.10.4

