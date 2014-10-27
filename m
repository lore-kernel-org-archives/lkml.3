Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752326AbaJ0HEI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2014 03:04:08 -0400
Received: from mail-pd0-f174.google.com ([209.85.192.174]:56294 "EHLO
	mail-pd0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752284AbaJ0HEF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2014 03:04:05 -0400
From: gyungoh@gmail.com
X-Google-Original-From: jack.yoo@skyworksinc.com
To: sameo@linux.intel.com, lee.jones@linaro.org, jg1.han@samsung.com,
        cooloney@gmail.com, broonie@kernel.org, lgirdwood@gmail.com
Cc: jack.yoo@skyworksinc.com, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, grant.likely@linaro.org,
        robh+dt@kernel.org, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org,
        pawel.moll@arm.com, heiko@sntech.de, jason@lakedaemon.net,
        shawn.guo@freescale.com, treding@nvidia.com, florian.vaussard@epfl.ch,
        trivial@kernel.org, linux@roeck-us.net, andrew@lunn.ch,
        jic23@kernel.org
Subject: [RESUBMIT PATCH v5 8/8] devicetree: regulator: sky81452: Add compatible string for device binding
Date: Mon, 27 Oct 2014 16:02:49 +0900
Message-Id: <1414393369-31583-9-git-send-email-jack.yoo@skyworksinc.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1414393369-31583-1-git-send-email-jack.yoo@skyworksinc.com>
References: <1413179262-27636-1-git-send-email-jack.yoo@skyworksinc.com>
 <1414393369-31583-1-git-send-email-jack.yoo@skyworksinc.com>
In-Reply-To: <1413179262-27636-1-git-send-email-jack.yoo@skyworksinc.com>
References: <1413179262-27636-1-git-send-email-jack.yoo@skyworksinc.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Gyungoh Yoo <jack.yoo@skyworksinc.com>

Signed-off-by: Gyungoh Yoo <jack.yoo@skyworksinc.com>
---
Changes v5:
Changed DT for regulator : 'lout' node should be defined under 'regulator'
Removed compatible string from sky81452-regulator driver

Changes v4:
Nothing

Changes v3:
Nothing

Changes v2:
Added 'compatible' attribute in the driver

 .../devicetree/bindings/regulator/sky81452-regulator.txt       | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/Documentation/devicetree/bindings/regulator/sky81452-regulator.txt b/Documentation/devicetree/bindings/regulator/sky81452-regulator.txt
index 882455e..f9acbc1 100644
--- a/Documentation/devicetree/bindings/regulator/sky81452-regulator.txt
+++ b/Documentation/devicetree/bindings/regulator/sky81452-regulator.txt
@@ -1,6 +1,7 @@
 SKY81452 voltage regulator
 
 Required properties:
+- regulator node named lout.
 - any required generic properties defined in regulator.txt
 
 Optional properties:
@@ -9,8 +10,9 @@ Optional properties:
 Example:
 
 	regulator {
-		/* generic regulator properties */
-		regulator-name = "touch_en";
-		regulator-min-microvolt = <4500000>;
-		regulator-max-microvolt = <8000000>;
+		lout {
+			regulator-name = "sky81452-lout";
+			regulator-min-microvolt = <4500000>;
+			regulator-max-microvolt = <8000000>;
+		};
 	};
-- 
1.9.1

