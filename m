Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752240AbaBETC5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Feb 2014 14:02:57 -0500
Received: from mail-oa0-f49.google.com ([209.85.219.49]:53311 "EHLO
	mail-oa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751354AbaBETCA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Feb 2014 14:02:00 -0500
From: Matt Porter <mporter@linaro.org>
To: Jonathan Cameron <jic23@kernel.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <robh+dt@kernel.org>,
        =?UTF-8?q?Beno=C3=AEt=20Cousson?= <bcousson@baylibre.com>,
        Tony Lindgren <tony@atomide.com>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Thierry Reding <thierry.reding@gmail.com>
Cc: Linux IIO List <linux-iio@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Devicetree List <devicetree@vger.kernel.org>,
        Linux PWM List <linux-pwm@vger.kernel.org>,
        Linux OMAP List <linux-omap@vger.kernel.org>,
        Linux ARM Kernel List <linux-arm-kernel@lists.infradead.org>
Subject: [PATCH v3 6/6] ARM: dts: AM33XX: Add ecap interrupt properties
Date: Wed,  5 Feb 2014 14:01:41 -0500
Message-Id: <1391626901-31684-7-git-send-email-mporter@linaro.org>
X-Mailer: git-send-email 1.8.4
In-Reply-To: <1391626901-31684-1-git-send-email-mporter@linaro.org>
References: <1391626901-31684-1-git-send-email-mporter@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add missing interrupt properties to the ecap0, ecap1, and ecap2
nodes.

Signed-off-by: Matt Porter <mporter@linaro.org>
---
 arch/arm/boot/dts/am33xx.dtsi | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/arch/arm/boot/dts/am33xx.dtsi b/arch/arm/boot/dts/am33xx.dtsi
index 6d95d3d..b4139ba 100644
--- a/arch/arm/boot/dts/am33xx.dtsi
+++ b/arch/arm/boot/dts/am33xx.dtsi
@@ -582,6 +582,8 @@
 				compatible = "ti,am33xx-ecap";
 				#pwm-cells = <3>;
 				reg = <0x48300100 0x80>;
+				interrupts = <31>;
+				interrupt-names = "ecap0";
 				ti,hwmods = "ecap0";
 				status = "disabled";
 			};
@@ -610,6 +612,8 @@
 				compatible = "ti,am33xx-ecap";
 				#pwm-cells = <3>;
 				reg = <0x48302100 0x80>;
+				interrupts = <47>;
+				interrupt-names = "ecap1";
 				ti,hwmods = "ecap1";
 				status = "disabled";
 			};
@@ -638,6 +642,8 @@
 				compatible = "ti,am33xx-ecap";
 				#pwm-cells = <3>;
 				reg = <0x48304100 0x80>;
+				interrupts = <61>;
+				interrupt-names = "ecap2";
 				ti,hwmods = "ecap2";
 				status = "disabled";
 			};
-- 
1.8.4

