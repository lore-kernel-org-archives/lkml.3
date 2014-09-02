Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754362AbaIBNOc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Sep 2014 09:14:32 -0400
Received: from ns.mm-sol.com ([37.157.136.199]:55811 "EHLO extserv.mm-sol.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754254AbaIBNO1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Sep 2014 09:14:27 -0400
From: Georgi Djakov <gdjakov@mm-sol.com>
To: linus.walleij@linaro.org, galak@codeaurora.org,
        bjorn.andersson@sonymobile.com, agross@codeaurora.org
Cc: robh+dt@kernel.org, mark.rutland@arm.com, grant.likely@linaro.org,
        sboyd@codeaurora.org, iivanov@mm-sol.com, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-arm-msm@vger.kernel.org, Georgi Djakov <gdjakov@mm-sol.com>
Subject: [PATCH v3 3/4] ARM: dts: qcom: Add TLMM DT node for APQ8084
Date: Tue,  2 Sep 2014 16:13:44 +0300
Message-Id: <1409663625-3185-4-git-send-email-gdjakov@mm-sol.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1409663625-3185-1-git-send-email-gdjakov@mm-sol.com>
References: <1409663625-3185-1-git-send-email-gdjakov@mm-sol.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds the TLMM node for the APQ8084 platform.

Reviewed-by: Bjorn Andersson <bjorn.andersson@sonymobile.com>
Signed-off-by: Georgi Djakov <gdjakov@mm-sol.com>
---
 arch/arm/boot/dts/qcom-apq8084.dtsi |   10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/arch/arm/boot/dts/qcom-apq8084.dtsi b/arch/arm/boot/dts/qcom-apq8084.dtsi
index b9ac63c..1f130bc 100644
--- a/arch/arm/boot/dts/qcom-apq8084.dtsi
+++ b/arch/arm/boot/dts/qcom-apq8084.dtsi
@@ -186,6 +186,16 @@
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

