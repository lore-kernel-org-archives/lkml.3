Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752171Ab3FZIvY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jun 2013 04:51:24 -0400
Received: from mail.free-electrons.com ([94.23.35.102]:47302 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751413Ab3FZIvS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jun 2013 04:51:18 -0400
From: Alexandre Belloni <alexandre.belloni@free-electrons.com>
To: Shawn Guo <shawn.guo@linaro.org>, Jean Delvare <khali@linux-fr.org>
Cc: jimwall@q.com, brian@crystalfontz.com,
        Maxime Ripard <maxime.ripard@free-electrons.com>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>, Rob Landley <rob@landley.net>,
        Guenter Roeck <linux@roeck-us.net>,
        Russell King <linux@arm.linux.org.uk>,
        devicetree-discuss@lists.ozlabs.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, lm-sensors@lm-sensors.org,
        linux-arm-kernel@lists.infradead.org,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>
Subject: [PATCH 2/4] arm: mxs: add lradc to cfa10036
Date: Wed, 26 Jun 2013 10:51:11 +0200
Message-Id: <1372236673-20725-3-git-send-email-alexandre.belloni@free-electrons.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1372236673-20725-1-git-send-email-alexandre.belloni@free-electrons.com>
References: <1372236673-20725-1-git-send-email-alexandre.belloni@free-electrons.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The lradc is actually available on the Crystalfontz cfa-10036.

Signed-off-by: Alexandre Belloni <alexandre.belloni@free-electrons.com>
---
 arch/arm/boot/dts/imx28-cfa10036.dts | 4 ++++
 arch/arm/boot/dts/imx28-cfa10049.dts | 1 -
 arch/arm/boot/dts/imx28-cfa10055.dts | 1 -
 3 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/arch/arm/boot/dts/imx28-cfa10036.dts b/arch/arm/boot/dts/imx28-cfa10036.dts
index 5e5213f..802e0e9 100644
--- a/arch/arm/boot/dts/imx28-cfa10036.dts
+++ b/arch/arm/boot/dts/imx28-cfa10036.dts
@@ -94,6 +94,10 @@
 			usbphy0: usbphy@8007c000 {
 				status = "okay";
 			};
+
+			lradc@80050000 {
+				status = "okay";
+			};
 		};
 	};
 
diff --git a/arch/arm/boot/dts/imx28-cfa10049.dts b/arch/arm/boot/dts/imx28-cfa10049.dts
index c26676b..4d3c0a6 100644
--- a/arch/arm/boot/dts/imx28-cfa10049.dts
+++ b/arch/arm/boot/dts/imx28-cfa10049.dts
@@ -215,7 +215,6 @@
 			};
 
 			lradc@80050000 {
-				status = "okay";
 				fsl,lradc-touchscreen-wires = <4>;
 			};
 		};
diff --git a/arch/arm/boot/dts/imx28-cfa10055.dts b/arch/arm/boot/dts/imx28-cfa10055.dts
index 1581112..e0de1aa 100644
--- a/arch/arm/boot/dts/imx28-cfa10055.dts
+++ b/arch/arm/boot/dts/imx28-cfa10055.dts
@@ -136,7 +136,6 @@
 		apbx@80040000 {
 			lradc@80050000 {
 				fsl,lradc-touchscreen-wires = <4>;
-				status = "okay";
 			};
 
 			pwm: pwm@80064000 {
-- 
1.8.1.2

