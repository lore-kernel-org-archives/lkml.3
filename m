Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751360AbaKYQZg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2014 11:25:36 -0500
Received: from mail-ie0-f169.google.com ([209.85.223.169]:33430 "EHLO
	mail-ie0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751294AbaKYQZb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2014 11:25:31 -0500
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: lee.jones@linaro.org, kernel@stlinux.com, tglx@linutronix.de,
        jason@lakedaemon.net, devicetree@vger.kernel.org
Subject: [PATCH v2 4/8] ARM: STi: STiH416: Enable Cortex-A9 PMU support
Date: Tue, 25 Nov 2014 16:25:01 +0000
Message-Id: <1416932705-16880-5-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1416932705-16880-1-git-send-email-lee.jones@linaro.org>
References: <1416932705-16880-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is ARM's generic Performance Monitoring Unit.

Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 arch/arm/boot/dts/stih416.dtsi | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/arch/arm/boot/dts/stih416.dtsi b/arch/arm/boot/dts/stih416.dtsi
index 84758d7..badefd6 100644
--- a/arch/arm/boot/dts/stih416.dtsi
+++ b/arch/arm/boot/dts/stih416.dtsi
@@ -21,6 +21,12 @@
 		cache-level = <2>;
 	};
 
+	arm-pmu {
+		compatible = "arm,cortex-a9-pmu";
+		interrupt-parent = <&intc>;
+		interrupts = <GIC_PPI 15 IRQ_TYPE_LEVEL_HIGH>;
+	};
+
 	soc {
 		#address-cells = <1>;
 		#size-cells = <1>;
-- 
1.9.1

