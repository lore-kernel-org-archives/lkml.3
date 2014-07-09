Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755171AbaGILEo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2014 07:04:44 -0400
Received: from mail-wi0-f176.google.com ([209.85.212.176]:42361 "EHLO
	mail-wi0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751294AbaGILEm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2014 07:04:42 -0400
From: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
To: Kishon Vijay Abraham I <kishon@ti.com>
Cc: Grant Likely <grant.likely@linaro.org>, Rob Herring <robh+dt@kernel.org>,
        linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-ide@vger.kernel.org,
        Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
Subject: [PATCH v2 2/2] phy: qcom: Update APQ8064 PHY device tree bindings
Date: Wed,  9 Jul 2014 12:04:37 +0100
Message-Id: <1404903877-26119-1-git-send-email-srinivas.kandagatla@linaro.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1404903807-26032-1-git-send-email-srinivas.kandagatla@linaro.org>
References: <1404903807-26032-1-git-send-email-srinivas.kandagatla@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Update binding spec for Qualcomm SoC PHYs with APQ8064 compatibles.

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

