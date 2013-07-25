Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756085Ab3GYN1y (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jul 2013 09:27:54 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:54007 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755678Ab3GYN1s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jul 2013 09:27:48 -0400
From: Oleksandr Kozaruk <oleksandr.kozaruk@ti.com>
To: <tony@atomide.com>, <benoit.cousson@linaro.org>, <rnayak@ti.com>,
        <peter.ujfalusi@ti.com>, <kishon@ti.com>, <jic23@cam.ac.uk>,
        <grant.likely@linaro.org>, <rob.herring@calxeda.com>,
        <lars@metafoo.de>, <sameo@linux.intel.com>, <ch.naveen@samsung.com>,
        <poeschel@lemonage.de>, <milo.kim@ti.com>, <balajitk@ti.com>,
        <gg@slimlogic.co.uk>
CC: <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        <linux-iio@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <linux-omap@vger.kernel.org>
Subject: [PATCH v8 1/2] ARM: dts: twl: Add GPADC data to device tree
Date: Thu, 25 Jul 2013 16:26:52 +0300
Message-ID: <1374758813-6539-2-git-send-email-oleksandr.kozaruk@ti.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1374758813-6539-1-git-send-email-oleksandr.kozaruk@ti.com>
References: <1374758813-6539-1-git-send-email-oleksandr.kozaruk@ti.com>
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
 arch/arm/boot/dts/twl6030.dtsi | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/arch/arm/boot/dts/twl6030.dtsi b/arch/arm/boot/dts/twl6030.dtsi
index 2e3bd31..b78e1d5 100644
--- a/arch/arm/boot/dts/twl6030.dtsi
+++ b/arch/arm/boot/dts/twl6030.dtsi
@@ -103,4 +103,10 @@
 		compatible = "ti,twl6030-pwmled";
 		#pwm-cells = <2>;
 	};
+
+	adc {
+		compatible = "ti,twl6030-gpadc";
+		interrupts = <3>;
+		#io-channel-cells = <1>;
+	};
 };
-- 
1.8.1.2

