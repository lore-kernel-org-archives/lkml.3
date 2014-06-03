Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932797AbaFCOZV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2014 10:25:21 -0400
Received: from ns.mm-sol.com ([37.157.136.199]:49811 "EHLO extserv.mm-sol.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932750AbaFCOZQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2014 10:25:16 -0400
From: Georgi Djakov <gdjakov@mm-sol.com>
To: mturquette@linaro.org
Cc: robh+dt@kernel.org, pawel.moll@arm.com, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org,
        sboyd@codeaurora.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        Georgi Djakov <gdjakov@mm-sol.com>
Subject: [PATCH v3 1/2] clk: qcom: Add APQ8084 Global Clock Controller documentation
Date: Tue,  3 Jun 2014 17:24:08 +0300
Message-Id: <1401805449-26499-2-git-send-email-gdjakov@mm-sol.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1401805449-26499-1-git-send-email-gdjakov@mm-sol.com>
References: <1401805449-26499-1-git-send-email-gdjakov@mm-sol.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add the compatible string for the APQ8084 global clock controller
to the clock binding documentation.

Signed-off-by: Georgi Djakov <gdjakov@mm-sol.com>
Reviewed-by: Stephen Boyd <sboyd@codeaurora.org>
---
 .../devicetree/bindings/clock/qcom,gcc.txt         |    1 +
 1 file changed, 1 insertion(+)

diff --git a/Documentation/devicetree/bindings/clock/qcom,gcc.txt b/Documentation/devicetree/bindings/clock/qcom,gcc.txt
index 9cfcb4f..4f35042 100644
--- a/Documentation/devicetree/bindings/clock/qcom,gcc.txt
+++ b/Documentation/devicetree/bindings/clock/qcom,gcc.txt
@@ -5,6 +5,7 @@ Required properties :
 - compatible : shall contain only one of the following:
 
 			"qcom,gcc-apq8064"
+			"qcom,gcc-apq8084"
 			"qcom,gcc-msm8660"
 			"qcom,gcc-msm8960"
 			"qcom,gcc-msm8974"
-- 
1.7.9.5

