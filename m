Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752814AbaJBMXp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Oct 2014 08:23:45 -0400
Received: from mailout2.w1.samsung.com ([210.118.77.12]:15441 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752563AbaJBMW0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Oct 2014 08:22:26 -0400
X-AuditID: cbfec7f4-b7f156d0000063c7-4f-542d437bc7eb
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: Sebastian Reichel <sre@kernel.org>,
        Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>,
        David Woodhouse <dwmw2@infradead.org>,
        Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, devicetree@vger.kernel.org,
        linux-api@vger.kernel.org
Cc: Ben Dooks <ben-linux@fluff.org>, Kukjin Kim <kgene.kim@samsung.com>,
        Russell King <linux@arm.linux.org.uk>,
        Javier Martinez Canillas <javier.martinez@collabora.co.uk>,
        linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Tomasz Figa <tomasz.figa@gmail.com>,
        Krzysztof Kozlowski <k.kozlowski@samsung.com>
Subject: [PATCH 3/7] devicetree: mfd: max77693: Document new bindings for
 charger
Date: Thu, 02 Oct 2014 14:22:04 +0200
Message-id: <1412252528-30148-4-git-send-email-k.kozlowski@samsung.com>
X-Mailer: git-send-email 1.9.1
In-reply-to: <1412252528-30148-1-git-send-email-k.kozlowski@samsung.com>
References: <1412252528-30148-1-git-send-email-k.kozlowski@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrOLMWRmVeSWpSXmKPExsVy+t/xq7rVzrohBrdeaFhsnLGe1WLSugNM
	FpOevGe2mH/kHKvFxJWTmS363yxktTj3aiWjxdHfBRavXxha9C64ymZxtukNu8X9r0cZLTZ/
	72Cz2PT4GqvF5V1z2Cw+9x5htJhxfh+Txe3LvBZrj9xlt1h6/SKTxYTpa1ksWvceYbc43c1q
	cXp3icWqXX8YHSQ91sxbw+jR0tzD5nG5r5fJ4+/z6ywef1e9YPbYOesuu8fK5V/YPDav0PLY
	tKqTzePOtT1sHvNOBnpsXlLv0bdlFaPH501yAXxRXDYpqTmZZalF+nYJXBmPL61nKtglXtFz
	8jNzA2OfcBcjJ4eEgInEq9kNLBC2mMSFe+vZuhi5OIQEljJK7JrVywrh9DFJPL33hh2kik3A
	WGLz8iVgVSICf5klJnx/xQTiMAs8ZZY4t2ELK0iVsECwxOHTu9hAbBYBVYmuTe/AbF4Bd4nu
	vfMYIfbJSZw8NhmsnlPAQ2Lu24lgG4SAatqaVrFNYORdwMiwilE0tTS5oDgpPddQrzgxt7g0
	L10vOT93EyMksr7sYFx8zOoQowAHoxIPb0aDTogQa2JZcWXuIUYJDmYlEd4n9rohQrwpiZVV
	qUX58UWlOanFhxiZODilGhgXNJ3XWxLAv+jGrs2dTJYfXvL98vGKOi7lYsJZfNbizxJ5wz0X
	i6fa5M91EkuSLuWYUx8VNa/x3e/DptaVZ9nYTedp2lcJvymfJzzXusluzWeOJbIuL++fzf8k
	ytMr7BCyIaVLOafa64TNPAcPwWNbu9+4Gyw94y3AsfqO3ZfWvNUhjVPublViKc5INNRiLipO
	BAA3GKHZigIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Document new device tree bindings for for Maxim 77693 charger driver.

Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Cc: devicetree@vger.kernel.org
Cc: Rob Herring <robh+dt@kernel.org>
Cc: Pawel Moll <pawel.moll@arm.com>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Ian Campbell <ijc+devicetree@hellion.org.uk>
Cc: Kumar Gala <galak@codeaurora.org>
---
 Documentation/devicetree/bindings/mfd/max77693.txt | 46 ++++++++++++++++++++++
 1 file changed, 46 insertions(+)

diff --git a/Documentation/devicetree/bindings/mfd/max77693.txt b/Documentation/devicetree/bindings/mfd/max77693.txt
index 11921cc417bf..d0c3d787df12 100644
--- a/Documentation/devicetree/bindings/mfd/max77693.txt
+++ b/Documentation/devicetree/bindings/mfd/max77693.txt
@@ -27,6 +27,42 @@ Optional properties:
 
 	[*] refer Documentation/devicetree/bindings/regulator/regulator.txt
 
+- charger : Node configuring the charger driver.
+  If present, required properties:
+  - compatible : Must be "maxim,max77693-charger".
+
+  Optional properties (if not set, defaults will be used):
+  - maxim,constant-microvolt : Battery constant voltage in uV. The charger
+    will operate in fast charge constant current mode till battery voltage
+    reaches this level. Then the charger will switch to fast charge constant
+    voltage mode. Also vsys (system voltage) will be set to this value when
+    DC power is supplied but charger is not enabled.
+    Valid values: 3650000 - 4400000, step by 25000 (rounded down)
+    Default: 4200000
+
+  - maxim,min-system-microvolt : Minimal system voltage in uV.
+    Valid values: 3000000 - 3700000, step by 100000 (rounded down)
+    Default: 3600000
+
+  - maxim,thermal-regulation-celsius : Temperature in Celsius for entering
+    high temperature charging mode. If die temperature exceeds this value
+    the charging current will be reduced by 105 mA/Celsius.
+    Valid values: 70, 85, 100, 115
+    Default: 100
+
+  - maxim,battery-overcurrent-microamp : Overcurrent protection threshold
+    in uA (current from battery to system).
+    Valid values: 2000000 - 3500000, step by 250000 (rounded down)
+    Default: 3500000
+
+  - maxim,charge-input-threshold-microvolt : Threshold voltage in uV for
+    triggering input voltage regulation loop. If input voltage decreases
+    below this value, the input current will be reduced to reach the
+    threshold voltage.
+    Valid values: 4300000, 4700000, 4800000, 4900000
+    Default: 4300000
+
+
 Example:
 	max77693@66 {
 		compatible = "maxim,max77693";
@@ -52,4 +88,14 @@ Example:
 					regulator-boot-on;
 			};
 		};
+
+		charger {
+			compatible = "maxim,max77693-charger";
+
+			maxim,constant-microvolt = <4200000>;
+			maxim,min-system-microvolt = <3600000>;
+			maxim,thermal-regulation-celsius = <75>;
+			maxim,battery-overcurrent-microamp = <3000000>;
+			maxim,charge-input-threshold-microvolt = <4300000>;
+		};
 	};
-- 
1.9.1

