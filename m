Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933631AbaLCAM3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2014 19:12:29 -0500
Received: from mail.kmu-office.ch ([178.209.48.109]:33420 "EHLO
	mail.kmu-office.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933408AbaLCAMY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2014 19:12:24 -0500
From: Stefan Agner <stefan@agner.ch>
To: shawn.guo@linaro.org, kernel@pengutronix.de, linux@arm.linux.org.uk,
        u.kleine-koenig@pengutronix.de, jason@lakedaemon.net, olof@lixom.net,
        arnd@arndb.de, daniel.lezcano@linaro.org, tglx@linutronix.de,
        mark.rutland@arm.com, pawel.moll@arm.com, robh+dt@kernel.org,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org
Cc: devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, Stefan Agner <stefan.agner@toradex.com>,
        Stefan Agner <stefan@agner.ch>
Subject: [PATCH 01/12] ARM: dts: vf610: add routable-irqs property for gic node
Date: Wed,  3 Dec 2014 01:12:00 +0100
Message-Id: <1417565531-4507-2-git-send-email-stefan@agner.ch>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <1417565531-4507-1-git-send-email-stefan@agner.ch>
References: <1417565531-4507-1-git-send-email-stefan@agner.ch>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stefan Agner <stefan.agner@toradex.com>

To enable proper routable interrupt controller support for
the GIC driver, the routable-irqs need to be specified.
Hence add the routable-irqs property with the amount of
IRQs supported by the GIC controller on the Vybrid SoC.

Signed-off-by: Stefan Agner <stefan@agner.ch>
---
 arch/arm/boot/dts/vf500.dtsi | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm/boot/dts/vf500.dtsi b/arch/arm/boot/dts/vf500.dtsi
index de67005..2b0d84d 100644
--- a/arch/arm/boot/dts/vf500.dtsi
+++ b/arch/arm/boot/dts/vf500.dtsi
@@ -30,6 +30,7 @@
 
 			intc: interrupt-controller@40002000 {
 				compatible = "arm,cortex-a9-gic";
+				arm,routable-irqs = <144>;
 				#interrupt-cells = <3>;
 				interrupt-controller;
 				reg = <0x40003000 0x1000>,
-- 
2.1.3

