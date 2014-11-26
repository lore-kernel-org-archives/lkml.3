Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753464AbaKZPPH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Nov 2014 10:15:07 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:59487 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753421AbaKZPPD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Nov 2014 10:15:03 -0500
From: Richard Fitzgerald <rf@opensource.wolfsonmicro.com>
To: lee.jones@linaro.org, broonie@kernel.org
Cc: cw00.choi@samsung.com, linus.walleij@linaro.org,
        devicetree@vger.kernel.org, alsa-devel@alsa-project.org,
        patches@opensource.wolfsonmicro.com, linux-kernel@vger.kernel.org,
        linux-gpio@vger.kernel.org, ckeepax@opensource.wolfsonmicro.com
Subject: [PATCH V2 2/6] Documentation: devicetree: arizona: Add bindings for WM8280
Date: Wed, 26 Nov 2014 15:13:04 +0000
Message-Id: <1417014788-8311-3-git-send-email-rf@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.2.5
In-Reply-To: <1417014788-8311-1-git-send-email-rf@opensource.wolfsonmicro.com>
References: <1417014788-8311-1-git-send-email-rf@opensource.wolfsonmicro.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Richard Fitzgerald <rf@opensource.wolfsonmicro.com>
---
 Documentation/devicetree/bindings/mfd/arizona.txt |   15 +++++++++++----
 1 files changed, 11 insertions(+), 4 deletions(-)

diff --git a/Documentation/devicetree/bindings/mfd/arizona.txt b/Documentation/devicetree/bindings/mfd/arizona.txt
index 7bd1273..87c878b 100644
--- a/Documentation/devicetree/bindings/mfd/arizona.txt
+++ b/Documentation/devicetree/bindings/mfd/arizona.txt
@@ -8,6 +8,7 @@ Required properties:
   - compatible : One of the following chip-specific strings:
         "wlf,wm5102"
         "wlf,wm5110"
+        "wlf,wm8280"
         "wlf,wm8997"
   - reg : I2C slave address when connected using I2C, chip select number when
     using SPI.
@@ -26,10 +27,16 @@ Required properties:
   - #gpio-cells : Must be 2. The first cell is the pin number and the
     second cell is used to specify optional parameters (currently unused).
 
-  - AVDD-supply, DBVDD1-supply, DBVDD2-supply, DBVDD3-supply (wm5102, wm5110),
-    CPVDD-supply, SPKVDDL-supply (wm5102, wm5110), SPKVDDR-supply (wm5102,
-    wm5110), SPKVDD-supply (wm8997) : Power supplies for the device, as covered
-    in Documentation/devicetree/bindings/regulator/regulator.txt
+  - AVDD-supply, DBVDD1-supply, CPVDD-supply : Power supplies for the device,
+    as covered in Documentation/devicetree/bindings/regulator/regulator.txt
+
+  - DBVDD2-supply, DBVDD3-supply : Additional databus power supplies (wm5102,
+    wm5110, wm8280)
+
+  - SPKVDDL-supply, SPKVDDR-supply : Speaker driver power supplies (wm5102,
+    wm5110, wm8280)
+
+  - SPKVDD-supply : Speaker driver power supply (wm8997)
 
 Optional properties:
 
-- 
1.7.2.5

