Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753408Ab3F0Kof (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Jun 2013 06:44:35 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:41232 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752018Ab3F0Kn5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Jun 2013 06:43:57 -0400
From: Oleksandr Kozaruk <oleksandr.kozaruk@ti.com>
To: <rob@landley.net>, <sameo@linux.intel.com>, <grant.likely@linaro.org>,
        <rob.herring@calxeda.com>, <balajitk@ti.com>, <gg@slimlogic.co.uk>
CC: <linux-doc@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-omap@vger.kernel.org>
Subject: [PATCH v1 1/2] ARM: dts: twl: Add GPADC data to device tree
Date: Thu, 27 Jun 2013 13:43:37 +0300
Message-ID: <1372329818-12384-2-git-send-email-oleksandr.kozaruk@ti.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1372329818-12384-1-git-send-email-oleksandr.kozaruk@ti.com>
References: <1372329818-12384-1-git-send-email-oleksandr.kozaruk@ti.com>
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
 arch/arm/boot/dts/twl6030.dtsi |    5 +++++
 1 file changed, 5 insertions(+)

diff --git a/arch/arm/boot/dts/twl6030.dtsi b/arch/arm/boot/dts/twl6030.dtsi
index 2e3bd31..189872c 100644
--- a/arch/arm/boot/dts/twl6030.dtsi
+++ b/arch/arm/boot/dts/twl6030.dtsi
@@ -103,4 +103,9 @@
 		compatible = "ti,twl6030-pwmled";
 		#pwm-cells = <2>;
 	};
+
+	twl6030_gpadc {
+		compatible = "ti,twl6030_gpadc";
+		interrupts = <3>;
+	};
 };
-- 
1.7.9.5

