Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753999AbaGNItT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2014 04:49:19 -0400
Received: from mail-we0-f177.google.com ([74.125.82.177]:42151 "EHLO
	mail-we0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753929AbaGNIs5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2014 04:48:57 -0400
From: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
To: Kishon Vijay Abraham I <kishon@ti.com>
Cc: Grant Likely <grant.likely@linaro.org>, Rob Herring <robh+dt@kernel.org>,
        linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-ide@vger.kernel.org,
        Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
Subject: [PATCH v3 2/2] phy: qcom: Update APQ8064 PHY device tree bindings
Date: Mon, 14 Jul 2014 09:48:53 +0100
Message-Id: <1405327733-27537-1-git-send-email-srinivas.kandagatla@linaro.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1405327664-27439-1-git-send-email-srinivas.kandagatla@linaro.org>
References: <1405327664-27439-1-git-send-email-srinivas.kandagatla@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add binding spec for Qualcomm SoC PHYs, starting with the SATA PHY on
the APQ8064 family of SoCs

Signed-off-by: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
---
 Documentation/devicetree/bindings/phy/qcom-phy.txt | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/Documentation/devicetree/bindings/phy/qcom-phy.txt b/Documentation/devicetree/bindings/phy/qcom-phy.txt
index 76bfbd0..6bff1e0 100644
--- a/Documentation/devicetree/bindings/phy/qcom-phy.txt
+++ b/Documentation/devicetree/bindings/phy/qcom-phy.txt
@@ -1,4 +1,4 @@
-Qualcomm IPQ806x SATA PHY Controller
+Qualcomm IPQ806x/APQ8064 SATA PHY Controller
 ------------------------------------
 
 SATA PHY nodes are defined to describe on-chip SATA Physical layer controllers.
@@ -6,6 +6,7 @@ Each SATA PHY controller should have its own node.
 
 Required properties:
 - compatible: compatible list, contains "qcom,ipq806x-sata-phy"
+	     or "qcom,apq8064-sata-phy".
 - reg: offset and length of the SATA PHY register set;
 - #phy-cells: must be zero
 - clocks: must be exactly one entry
-- 
1.9.1

