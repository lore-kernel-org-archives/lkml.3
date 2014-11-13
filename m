Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933763AbaKMRxf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2014 12:53:35 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:59038 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933609AbaKMRwN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2014 12:52:13 -0500
From: Richard Fitzgerald <rf@opensource.wolfsonmicro.com>
To: lee.jones@linaro.org, lgirdwood@gmail.com, myungjoo.ham@samsung.com,
        cw00.choi@samsung.com, linus.walleij@linaro.org, gnurou@gmail.com,
        broonie@kernel.org, tiwai@suse.de
Cc: perex@perex.cz, sameo@linux.intel.com, robh+dt@kernel.org,
        pawel.moll@arm.com, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org,
        ckeepax@opensource.wolfsonmicro.com, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, patches@opensource.wolfsonmicro.com,
        linux-gpio@vger.kernel.org, alsa-devel@alsa-project.org
Subject: [PATCH 2/6] Documentation: devicetree: arizona: Add bindings for WM8280
Date: Thu, 13 Nov 2014 17:50:42 +0000
Message-Id: <1415901046-3391-3-git-send-email-rf@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.2.5
In-Reply-To: <1415901046-3391-1-git-send-email-rf@opensource.wolfsonmicro.com>
References: <1415901046-3391-1-git-send-email-rf@opensource.wolfsonmicro.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Richard Fitzgerald <rf@opensource.wolfsonmicro.com>
---
 Documentation/devicetree/bindings/mfd/arizona.txt |   10 ++++++----
 1 files changed, 6 insertions(+), 4 deletions(-)

diff --git a/Documentation/devicetree/bindings/mfd/arizona.txt b/Documentation/devicetree/bindings/mfd/arizona.txt
index 7bd1273..079badb 100644
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
@@ -26,10 +27,11 @@ Required properties:
   - #gpio-cells : Must be 2. The first cell is the pin number and the
     second cell is used to specify optional parameters (currently unused).
 
-  - AVDD-supply, DBVDD1-supply, DBVDD2-supply, DBVDD3-supply (wm5102, wm5110),
-    CPVDD-supply, SPKVDDL-supply (wm5102, wm5110), SPKVDDR-supply (wm5102,
-    wm5110), SPKVDD-supply (wm8997) : Power supplies for the device, as covered
-    in Documentation/devicetree/bindings/regulator/regulator.txt
+  - AVDD-supply, DBVDD1-supply, DBVDD2-supply, DBVDD3-supply (wm5102, wm5110,
+    wm8280), CPVDD-supply, SPKVDDL-supply (wm5102, wm5110, wm8280),
+    SPKVDDR-supply (wm5102, wm5110, wm8280), SPKVDD-supply (wm8997)
+    : Power supplies for the device, as covered in
+    Documentation/devicetree/bindings/regulator/regulator.txt
 
 Optional properties:
 
-- 
1.7.2.5

