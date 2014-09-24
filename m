Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752914AbaIXVm6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2014 17:42:58 -0400
Received: from bhuna.collabora.co.uk ([93.93.135.160]:44680 "EHLO
	bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751237AbaIXVm4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2014 17:42:56 -0400
From: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
To: Kukjin Kim <kgene.kim@samsung.com>
Cc: Doug Anderson <dianders@chromium.org>, Andreas Faerber <afaerber@suse.de>,
        linux-samsung-soc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Javier Martinez Canillas <javier.martinez@collabora.co.uk>
Subject: [PATCH 2/2] ARM: dts: Remove display timings node from exynos5250-snow
Date: Wed, 24 Sep 2014 23:42:37 +0200
Message-Id: <1411594957-10681-2-git-send-email-javier.martinez@collabora.co.uk>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1411594957-10681-1-git-send-email-javier.martinez@collabora.co.uk>
References: <1411594957-10681-1-git-send-email-javier.martinez@collabora.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit a3d72ca ("ARM: dts: Clean up exynos5250-snow") improved
the Snow DTS but the patch was rebased due conflicting changes
and the merge resolution added a device node removed by commit
a98c3c2 ("ARM: dts: update display related nodes for exynos5250-snow").

This patch removes the node again to keep the DTS as before.

Signed-off-by: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
---
 arch/arm/boot/dts/exynos5250-snow.dts | 16 ----------------
 1 file changed, 16 deletions(-)

diff --git a/arch/arm/boot/dts/exynos5250-snow.dts b/arch/arm/boot/dts/exynos5250-snow.dts
index e562459..f9bc04b 100644
--- a/arch/arm/boot/dts/exynos5250-snow.dts
+++ b/arch/arm/boot/dts/exynos5250-snow.dts
@@ -241,22 +241,6 @@
 	samsung,lane-count = <2>;
 	samsung,hpd-gpio = <&gpx0 7 GPIO_ACTIVE_HIGH>;
 	bridge = <&ptn3460>;
-
-	display-timings {
-		native-mode = <&timing1>;
-
-		timing1: timing@1 {
-			clock-frequency = <70589280>;
-			hactive = <1366>;
-			vactive = <768>;
-			hfront-porch = <40>;
-			hback-porch = <40>;
-			hsync-len = <32>;
-			vback-porch = <10>;
-			vfront-porch = <12>;
-			vsync-len = <6>;
-		};
-	};
 };
 
 &ehci {
-- 
2.1.0

