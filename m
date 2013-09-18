Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753456Ab3IRVyb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Sep 2013 17:54:31 -0400
Received: from mail-ea0-f181.google.com ([209.85.215.181]:42428 "EHLO
	mail-ea0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751873Ab3IRVya (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Sep 2013 17:54:30 -0400
From: =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali.rohar@gmail.com>
To: Tony Lindgren <tony@atomide.com>, Russell King <linux@arm.linux.org.uk>
Cc: linux-omap@vger.kernel.org, linux-kernel@vger.kernel.org,
        =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali.rohar@gmail.com>
Subject: =?UTF-8?q?=5BPATCH=5D=20RX-51=3A=20Add=20missing=20max=5Fcurrent=20to=20rx51=5Flp5523=5Fled=5Fconfig?=
Date: Wed, 18 Sep 2013 23:52:25 +0200
Message-Id: <1379541145-25934-1-git-send-email-pali.rohar@gmail.com>
X-Mailer: git-send-email 1.7.10.4
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Without max_current data in board file lp5523 driver does not change current.

Signed-off-by: Pali Rohár <pali.rohar@gmail.com>
---
 arch/arm/mach-omap2/board-rx51-peripherals.c |    9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/arch/arm/mach-omap2/board-rx51-peripherals.c b/arch/arm/mach-omap2/board-rx51-peripherals.c
index 9326890..d0f857c 100644
--- a/arch/arm/mach-omap2/board-rx51-peripherals.c
+++ b/arch/arm/mach-omap2/board-rx51-peripherals.c
@@ -180,38 +180,47 @@ static struct lp55xx_led_config rx51_lp5523_led_config[] = {
 		.name		= "lp5523:kb1",
 		.chan_nr	= 0,
 		.led_current	= 50,
+		.max_current	= 255,
 	}, {
 		.name		= "lp5523:kb2",
 		.chan_nr	= 1,
 		.led_current	= 50,
+		.max_current	= 255,
 	}, {
 		.name		= "lp5523:kb3",
 		.chan_nr	= 2,
 		.led_current	= 50,
+		.max_current	= 255,
 	}, {
 		.name		= "lp5523:kb4",
 		.chan_nr	= 3,
 		.led_current	= 50,
+		.max_current	= 255,
 	}, {
 		.name		= "lp5523:b",
 		.chan_nr	= 4,
 		.led_current	= 50,
+		.max_current	= 255,
 	}, {
 		.name		= "lp5523:g",
 		.chan_nr	= 5,
 		.led_current	= 50,
+		.max_current	= 255,
 	}, {
 		.name		= "lp5523:r",
 		.chan_nr	= 6,
 		.led_current	= 50,
+		.max_current	= 255,
 	}, {
 		.name		= "lp5523:kb5",
 		.chan_nr	= 7,
 		.led_current	= 50,
+		.max_current	= 255,
 	}, {
 		.name		= "lp5523:kb6",
 		.chan_nr	= 8,
 		.led_current	= 50,
+		.max_current	= 255,
 	}
 };
 
-- 
1.7.10.4

