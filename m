Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753757Ab3KNM0h (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Nov 2013 07:26:37 -0500
Received: from devils.ext.ti.com ([198.47.26.153]:57128 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753682Ab3KNM0d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Nov 2013 07:26:33 -0500
From: Sricharan R <r.sricharan@ti.com>
To: <r.sricharan@ti.com>, <linux-kernel@vger.kernel.org>,
        <devicetree@vger.kernel.org>, <linux-doc@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-omap@vger.kernel.org>,
        <linus.walleij@linaro.org>, <linux@arm.linux.org.uk>,
        <tony@atomide.com>, <rnayak@ti.com>, <marc.zyngier@arm.com>,
        <grant.likely@linaro.org>, <mark.rutland@arm.com>,
        <robherring2@gmail.com>, <tglx@linutronix.de>, <galak@codeaurora.org>,
        <rob.herring@calxeda.com>, <santosh.shilimkar@ti.com>, <nm@ti.com>,
        <bcousson@baylibre.com>
Subject: [PATCH V4 3/3] ARM: DTS: DRA7: Add routable-irqs property for gic node
Date: Thu, 14 Nov 2013 17:55:27 +0530
Message-ID: <1384431928-2328-4-git-send-email-r.sricharan@ti.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1384431928-2328-1-git-send-email-r.sricharan@ti.com>
References: <1384431928-2328-1-git-send-email-r.sricharan@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There is a IRQ crossbar device in the soc, which maps the
irq requests from the peripherals to the mpu interrupt
controller's inputs. The gic provides the support for such
IPs in the form of routable-irqs. So adding the property
here to gic node.

Cc: Benoit Cousson <bcousson@baylibre.com>
Cc: Santosh Shilimkar <santosh.shilimkar@ti.com>
Cc: Rajendra Nayak <rnayak@ti.com>
Cc: Tony Lindgren <tony@atomide.com>
Signed-off-by: Sricharan R <r.sricharan@ti.com>
Acked-by: Santosh Shilimkar <santosh.shilimkar@ti.com>
---
 arch/arm/boot/dts/dra7.dtsi |    1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm/boot/dts/dra7.dtsi b/arch/arm/boot/dts/dra7.dtsi
index 8b93b7a..fd58a09 100644
--- a/arch/arm/boot/dts/dra7.dtsi
+++ b/arch/arm/boot/dts/dra7.dtsi
@@ -67,6 +67,7 @@
 		compatible = "arm,cortex-a15-gic";
 		interrupt-controller;
 		#interrupt-cells = <3>;
+		arm,routable-irqs = <160>;
 		reg = <0x48211000 0x1000>,
 		      <0x48212000 0x1000>,
 		      <0x48214000 0x2000>,
-- 
1.7.9.5

