Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753906AbaEaPqc (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 May 2014 11:46:32 -0400
Received: from ns.mm-sol.com ([37.157.136.199]:44688 "EHLO extserv.mm-sol.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752633AbaEaPq0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 May 2014 11:46:26 -0400
From: Georgi Djakov <gdjakov@mm-sol.com>
To: mturquette@linaro.org, linux@arm.linux.org.uk, robh+dt@kernel.org,
        pawel.moll@arm.com, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org,
        sboyd@codeaurora.org, rdunlap@infradead.org
Cc: linux-doc@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, Georgi Djakov <gdjakov@mm-sol.com>
Subject: [PATCH v2 1/4] clk: qcom: Add APQ8084 Global Clock Controller documentation
Date: Sat, 31 May 2014 18:45:31 +0300
Message-Id: <1401551134-28485-2-git-send-email-gdjakov@mm-sol.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1401551134-28485-1-git-send-email-gdjakov@mm-sol.com>
References: <1401551134-28485-1-git-send-email-gdjakov@mm-sol.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add the compatible string for the APQ8084 global clock controller
to the clock binding documentation.

Signed-off-by: Georgi Djakov <gdjakov@mm-sol.com>
---
 .../devicetree/bindings/clock/qcom,gcc.txt         |    1 +
 1 file changed, 1 insertion(+)

diff --git a/Documentation/devicetree/bindings/clock/qcom,gcc.txt b/Documentation/devicetree/bindings/clock/qcom,gcc.txt
index 7b7104e..13fc1ef 100644
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

