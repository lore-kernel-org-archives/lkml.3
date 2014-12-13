Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933061AbaLMBrI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Dec 2014 20:47:08 -0500
Received: from mail-wi0-f171.google.com ([209.85.212.171]:61564 "EHLO
	mail-wi0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932942AbaLMBrE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Dec 2014 20:47:04 -0500
From: Silvio Fricke <silvio.fricke@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Silvio Fricke <silvio.fricke@gmail.com>,
        linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>,
        Jason Cooper <jason@lakedaemon.net>,
        Marc Zyngier <marc.zyngier@arm.com>
Subject: [PATCH 1/3] ARM: mx5: dts: remove unused irq-trigger entry
Date: Sat, 13 Dec 2014 02:46:46 +0100
Message-Id: <73b964064f87e3e632cc251894c130b88aaaf0b8.1418434448.git.silvio.fricke@gmail.com>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <cover.1418434448.git.silvio.fricke@gmail.com>
References: <cover.1418434448.git.silvio.fricke@gmail.com>
In-Reply-To: <cover.1418434448.git.silvio.fricke@gmail.com>
References: <cover.1418434448.git.silvio.fricke@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Silvio Fricke <silvio.fricke@gmail.com>
CC: Thomas Gleixner <tglx@linutronix.de>
CC: Jason Cooper <jason@lakedaemon.net>
CC: Marc Zyngier <marc.zyngier@arm.com>
---
 arch/arm/boot/dts/imx53-m53.dtsi | 1 -
 1 file changed, 1 deletion(-)

diff --git a/arch/arm/boot/dts/imx53-m53.dtsi b/arch/arm/boot/dts/imx53-m53.dtsi
index 87a7fc7..8a5acb5 100644
--- a/arch/arm/boot/dts/imx53-m53.dtsi
+++ b/arch/arm/boot/dts/imx53-m53.dtsi
@@ -60,7 +60,6 @@
 		blocks = <0x5>;
 		interrupts = <6 0x0>;
 		interrupt-parent = <&gpio7>;
-		irq-trigger = <0x1>;
 
 		stmpe_touchscreen {
 			compatible = "st,stmpe-ts";
-- 
2.1.3

