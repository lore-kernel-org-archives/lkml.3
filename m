Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751716AbaHZPlC (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2014 11:41:02 -0400
Received: from ns.mm-sol.com ([37.157.136.199]:45491 "EHLO extserv.mm-sol.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751645AbaHZPk7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2014 11:40:59 -0400
From: Georgi Djakov <gdjakov@mm-sol.com>
To: galak@codeaurora.org
Cc: robh+dt@kernel.org, pawel.moll@arm.com, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, linux@arm.linux.org.uk,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, iivanov@mm-sol.com,
        Georgi Djakov <gdjakov@mm-sol.com>
Subject: [PATCH v1 1/2] ARM: dts: qcom: Add initial IFC6540 board device tree
Date: Tue, 26 Aug 2014 18:39:37 +0300
Message-Id: <1409067578-30272-2-git-send-email-gdjakov@mm-sol.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1409067578-30272-1-git-send-email-gdjakov@mm-sol.com>
References: <1409067578-30272-1-git-send-email-gdjakov@mm-sol.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add initial device tree for the IFC6540 Snapdragon 805 pico-itx
single-board computer.

Signed-off-by: Georgi Djakov <gdjakov@mm-sol.com>
---
 arch/arm/boot/dts/Makefile                 |    1 +
 arch/arm/boot/dts/qcom-apq8084-ifc6540.dts |    6 ++++++
 2 files changed, 7 insertions(+)
 create mode 100644 arch/arm/boot/dts/qcom-apq8084-ifc6540.dts

diff --git a/arch/arm/boot/dts/Makefile b/arch/arm/boot/dts/Makefile
index b022972..df8453a 100644
--- a/arch/arm/boot/dts/Makefile
+++ b/arch/arm/boot/dts/Makefile
@@ -345,6 +345,7 @@ dtb-$(CONFIG_ARCH_PRIMA2) += prima2-evb.dtb
 dtb-$(CONFIG_ARCH_QCOM) += \
 	qcom-apq8064-ifc6410.dtb \
 	qcom-apq8074-dragonboard.dtb \
+	qcom-apq8084-ifc6540.dtb \
 	qcom-apq8084-mtp.dtb \
 	qcom-msm8660-surf.dtb \
 	qcom-msm8960-cdp.dtb
diff --git a/arch/arm/boot/dts/qcom-apq8084-ifc6540.dts b/arch/arm/boot/dts/qcom-apq8084-ifc6540.dts
new file mode 100644
index 0000000..4603e91
--- /dev/null
+++ b/arch/arm/boot/dts/qcom-apq8084-ifc6540.dts
@@ -0,0 +1,6 @@
+#include "qcom-apq8084.dtsi"
+
+/ {
+	model = "Qualcomm APQ8084/IFC6540";
+	compatible = "qcom,apq8084-ifc6540", "qcom,apq8084";
+};
-- 
1.7.9.5

