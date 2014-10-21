Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755893AbaJURrA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2014 13:47:00 -0400
Received: from mail-la0-f50.google.com ([209.85.215.50]:40512 "EHLO
	mail-la0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933416AbaJURo7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2014 13:44:59 -0400
X-Google-Original-Sender: <johan@hovold.com>
From: Johan Hovold <johan@kernel.org>
To: Alessandro Zummo <a.zummo@towertech.it>, Tony Lindgren <tony@atomide.com>,
        =?UTF-8?q?Beno=C3=AEt=20Cousson?= <bcousson@baylibre.com>,
        Felipe Balbi <balbi@ti.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Lokesh Vutla <lokeshvutla@ti.com>, Guenter Roeck <linux@roeck-us.net>,
        nsekhar@ti.com, t-kristo@ti.com, j-keerthy@ti.com,
        linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        devicetree@vger.kernel.org, rtc-linux@googlegroups.com,
        linux-kernel@vger.kernel.org, Johan Hovold <johan@kernel.org>
Subject: [PATCH v2 19/20] ARM: dts: am33xx: update rtc-node compatible property
Date: Tue, 21 Oct 2014 19:38:05 +0200
Message-Id: <1413913086-12730-20-git-send-email-johan@kernel.org>
X-Mailer: git-send-email 2.0.4
In-Reply-To: <1413913086-12730-1-git-send-email-johan@kernel.org>
References: <1412881594-25678-1-git-send-email-johan@kernel.org>
 <1413913086-12730-1-git-send-email-johan@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Enable am33xx specific RTC features (e.g. PMIC control) by adding
"ti,am3352-rtc" to the compatible property of the rtc node.

Reviewed-by: Felipe Balbi <balbi@ti.com>
Signed-off-by: Johan Hovold <johan@kernel.org>
---
 arch/arm/boot/dts/am33xx.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/boot/dts/am33xx.dtsi b/arch/arm/boot/dts/am33xx.dtsi
index 3a0a161342ba..098e53602d5c 100644
--- a/arch/arm/boot/dts/am33xx.dtsi
+++ b/arch/arm/boot/dts/am33xx.dtsi
@@ -411,7 +411,7 @@
 		};
 
 		rtc: rtc@44e3e000 {
-			compatible = "ti,da830-rtc";
+			compatible = "ti,am3352-rtc", "ti,da830-rtc";
 			reg = <0x44e3e000 0x1000>;
 			interrupts = <75
 				      76>;
-- 
2.0.4

