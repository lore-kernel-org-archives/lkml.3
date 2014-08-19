Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753822AbaHSRXG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Aug 2014 13:23:06 -0400
Received: from ns.mm-sol.com ([37.157.136.199]:32929 "EHLO extserv.mm-sol.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753737AbaHSRXE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Aug 2014 13:23:04 -0400
From: Georgi Djakov <gdjakov@mm-sol.com>
To: linus.walleij@linaro.org, galak@codeaurora.org,
        bjorn.andersson@sonymobile.com
Cc: robh+dt@kernel.org, mark.rutland@arm.com, grant.likely@linaro.org,
        sboyd@codeaurora.org, agross@codeaurora.org, iivanov@mm-sol.com,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-arm-msm@vger.kernel.org,
        Georgi Djakov <gdjakov@mm-sol.com>
Subject: [PATCH v1 3/3] ARM: dts: Add TLMM DT node for apq8084
Date: Tue, 19 Aug 2014 20:22:16 +0300
Message-Id: <1408468936-12252-4-git-send-email-gdjakov@mm-sol.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1408468936-12252-1-git-send-email-gdjakov@mm-sol.com>
References: <1408468936-12252-1-git-send-email-gdjakov@mm-sol.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds the TLMM node for the apq8084 platform.

Signed-off-by: Georgi Djakov <gdjakov@mm-sol.com>
---
 arch/arm/boot/dts/qcom-apq8084.dtsi |   10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/arch/arm/boot/dts/qcom-apq8084.dtsi b/arch/arm/boot/dts/qcom-apq8084.dtsi
index b5b156e..21d01e5 100644
--- a/arch/arm/boot/dts/qcom-apq8084.dtsi
+++ b/arch/arm/boot/dts/qcom-apq8084.dtsi
@@ -185,6 +185,16 @@
 			reg = <0xfc400000 0x4000>;
 		};
 
+		tlmm: pinctrl@fd510000 {
+			compatible = "qcom,apq8084-pinctrl";
+			reg = <0xfd510000 0x4000>;
+			gpio-controller;
+			#gpio-cells = <2>;
+			interrupt-controller;
+			#interrupt-cells = <2>;
+			interrupts = <0 208 0>;
+		};
+
 		serial@f995e000 {
 			compatible = "qcom,msm-uartdm-v1.4", "qcom,msm-uartdm";
 			reg = <0xf995e000 0x1000>;
-- 
1.7.9.5

