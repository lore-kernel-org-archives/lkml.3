Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753423Ab3GJHJv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Jul 2013 03:09:51 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:59728 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752030Ab3GJHJs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Jul 2013 03:09:48 -0400
From: Oleksandr Kozaruk <oleksandr.kozaruk@ti.com>
To: <tony@atomide.com>, <gg@slimlogic.co.uk>, <peter.ujfalusi@ti.com>,
        <kishon@ti.com>, <benoit.cousson@linaro.org>,
        <grant.likely@linaro.org>, <rob.herring@calxeda.com>,
        <sameo@linux.intel.com>, <ch.naveen@samsung.com>, <milo.kim@ti.com>,
        <poeschel@lemonage.de>, <balajitk@ti.com>
CC: <linux-kernel@vger.kernel.org>, <linux-iio@vger.kernel.org>,
        <devicetree-discuss@lists.ozlabs.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-omap@vger.kernel.org>
Subject: [PATCH v2 1/2] ARM: dts: twl: Add GPADC data to device tree
Date: Wed, 10 Jul 2013 10:08:53 +0300
Message-ID: <1373440134-30118-2-git-send-email-oleksandr.kozaruk@ti.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1373440134-30118-1-git-send-email-oleksandr.kozaruk@ti.com>
References: <1373440134-30118-1-git-send-email-oleksandr.kozaruk@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

GPADC is the general purpose ADC present on twl6030.
The dt data is interrupt used to trigger end of ADC
conversion.

Signed-off-by: Oleksandr Kozaruk <oleksandr.kozaruk@ti.com>
---
 arch/arm/boot/dts/twl6030.dtsi |    6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/arch/arm/boot/dts/twl6030.dtsi b/arch/arm/boot/dts/twl6030.dtsi
index 2e3bd31..434842c 100644
--- a/arch/arm/boot/dts/twl6030.dtsi
+++ b/arch/arm/boot/dts/twl6030.dtsi
@@ -103,4 +103,10 @@
 		compatible = "ti,twl6030-pwmled";
 		#pwm-cells = <2>;
 	};
+
+	gpadc: twl6030_gpadc {
+		compatible = "ti,twl6030_gpadc";
+		interrupts = <3>;
+		#io-channel-cells = <1>;
+	};
 };
-- 
1.7.9.5

