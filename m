Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753508AbbAVJuS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2015 04:50:18 -0500
Received: from mail-ie0-f174.google.com ([209.85.223.174]:49565 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752244AbbAVJtQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2015 04:49:16 -0500
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: lee.jones@linaro.org, kernel@stlinux.com, tglx@linutronix.de,
        jason@lakedaemon.net, devicetree@vger.kernel.org
Subject: [PATCH v2 RESEND 6/8] ARM: STi: STiH407: Enable Cortex-A9 PMU support
Date: Thu, 22 Jan 2015 09:48:51 +0000
Message-Id: <1421920133-7914-7-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1421920133-7914-1-git-send-email-lee.jones@linaro.org>
References: <1421920133-7914-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is ARM's generic Performance Monitoring Unit.

Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 arch/arm/boot/dts/stih407-family.dtsi | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/arch/arm/boot/dts/stih407-family.dtsi b/arch/arm/boot/dts/stih407-family.dtsi
index 3e31d32..939e46e 100644
--- a/arch/arm/boot/dts/stih407-family.dtsi
+++ b/arch/arm/boot/dts/stih407-family.dtsi
@@ -56,6 +56,12 @@
 		cache-level = <2>;
 	};
 
+	arm-pmu {
+		interrupt-parent = <&intc>;
+		compatible = "arm,cortex-a9-pmu";
+		interrupts = <GIC_PPI 15 IRQ_TYPE_LEVEL_HIGH>;
+	};
+
 	soc {
 		#address-cells = <1>;
 		#size-cells = <1>;
-- 
1.9.1

