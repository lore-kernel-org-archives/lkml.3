Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754299Ab3FIQgR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Jun 2013 12:36:17 -0400
Received: from mail.free-electrons.com ([94.23.35.102]:56928 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751844Ab3FIQgP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Jun 2013 12:36:15 -0400
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Emilio Lopez <emilio@elopez.com.ar>, kevin@allwinnertech.com,
        sunny@allwinnertech.com, shuge@allwinnertech.com,
        linux-sunxi@googlegroups.com,
        Maxime Ripard <maxime.ripard@free-electrons.com>
Subject: [PATCH 1/6] ARM: sunxi: Add Allwinner A10s machine compatible
Date: Sun,  9 Jun 2013 18:36:02 +0200
Message-Id: <1370795767-9769-2-git-send-email-maxime.ripard@free-electrons.com>
X-Mailer: git-send-email 1.8.3
In-Reply-To: <1370795767-9769-1-git-send-email-maxime.ripard@free-electrons.com>
References: <1370795767-9769-1-git-send-email-maxime.ripard@free-electrons.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The A10s is a SoC member of the Allwinner sun5i family. It is basically
an A13 with an EMAC and an HDMI controller.

Signed-off-by: Maxime Ripard <maxime.ripard@free-electrons.com>
---
 Documentation/arm/sunxi/README | 4 ++++
 arch/arm/mach-sunxi/sunxi.c    | 1 +
 2 files changed, 5 insertions(+)

diff --git a/Documentation/arm/sunxi/README b/Documentation/arm/sunxi/README
index d9a372d..e3f93fb 100644
--- a/Documentation/arm/sunxi/README
+++ b/Documentation/arm/sunxi/README
@@ -17,6 +17,10 @@ SunXi family
 	+ User Manual
 	  http://dl.linux-sunxi.org/A10/A10%20User%20Manual%20-%20v1.20%20%282012-04-09%2c%20DECRYPTED%29.pdf
 
+      - Allwinner A10s (sun5i)
+        + Datasheet
+          http://dl.linux-sunxi.org/A10s/A10s%20Datasheet%20-%20v1.20%20%282012-03-27%29.pdf
+
       - Allwinner A13 (sun5i)
         + Datasheet
 	  http://dl.linux-sunxi.org/A13/A13%20Datasheet%20-%20v1.12%20%282012-03-29%29.pdf
diff --git a/arch/arm/mach-sunxi/sunxi.c b/arch/arm/mach-sunxi/sunxi.c
index 08937a3..a42d874 100644
--- a/arch/arm/mach-sunxi/sunxi.c
+++ b/arch/arm/mach-sunxi/sunxi.c
@@ -109,6 +109,7 @@ static void __init sunxi_dt_init(void)
 
 static const char * const sunxi_board_dt_compat[] = {
 	"allwinner,sun4i-a10",
+	"allwinner,sun5i-a10s",
 	"allwinner,sun5i-a13",
 	NULL,
 };
-- 
1.8.3

