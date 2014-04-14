Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755281AbaDNSvT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2014 14:51:19 -0400
Received: from mail-ie0-f181.google.com ([209.85.223.181]:55173 "EHLO
	mail-ie0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755112AbaDNSun (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2014 14:50:43 -0400
From: Matt Porter <mporter@linaro.org>
To: Devicetree List <devicetree@vger.kernel.org>,
        Lee Jones <lee.jones@linaro.org>, Samuel Ortiz <sameo@linux.intel.com>,
        Liam Girdwood <lgirdwood@gmail.com>, Mark Brown <broonie@kernel.org>
Cc: Tim Kryger <tim.kryger@linaro.org>, Markus Mayer <markus.mayer@linaro.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux ARM Kernel List <linux-arm-kernel@lists.infradead.org>
Subject: [PATCH 4/4] ARM: dts: bcm590xx: add support for GPLDO and VBUS regulators
Date: Mon, 14 Apr 2014 14:50:28 -0400
Message-Id: <1397501428-8857-5-git-send-email-mporter@linaro.org>
X-Mailer: git-send-email 1.8.4
In-Reply-To: <1397501428-8857-1-git-send-email-mporter@linaro.org>
References: <1397501428-8857-1-git-send-email-mporter@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adds additional nodes to support GPLDO1-6 and VBUS regulators which
are not supported in the bcm590xx regulator driver.

Signed-off-by: Matt Porter <mporter@linaro.org>
---
 arch/arm/boot/dts/bcm59056.dtsi | 21 +++++++++++++++++++++
 1 file changed, 21 insertions(+)

diff --git a/arch/arm/boot/dts/bcm59056.dtsi b/arch/arm/boot/dts/bcm59056.dtsi
index dfadaaa..066adfb 100644
--- a/arch/arm/boot/dts/bcm59056.dtsi
+++ b/arch/arm/boot/dts/bcm59056.dtsi
@@ -70,5 +70,26 @@
 
 		vsr_reg: vsr {
 		};
+
+		gpldo1_reg: gpldo1 {
+		};
+
+		gpldo2_reg: gpldo2 {
+		};
+
+		gpldo3_reg: gpldo3 {
+		};
+
+		gpldo4_reg: gpldo4 {
+		};
+
+		gpldo5_reg: gpldo5 {
+		};
+
+		gpldo6_reg: gpldo6 {
+		};
+
+		vbus_reg: vbus {
+		};
 	};
 };
-- 
1.8.4

