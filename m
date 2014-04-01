Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751817AbaDAIiq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2014 04:38:46 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:51391 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751486AbaDAIgW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2014 04:36:22 -0400
From: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
To: broonie@kernel.org
Cc: lee.jones@linaro.org, robh+dt@kernel.org, pawel.moll@arm.com,
        mark.rutland@arm.com, ijc+devicetree@hellion.org.uk,
        galak@codeaurora.org, rob@landley.net, sameo@linux.intel.com,
        lgirdwood@gmail.com, ckeepax@opensource.wolfsonmicro.com,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 6/6] mfd: arizona: Update DT binding to support MICVDD init_data
Date: Tue,  1 Apr 2014 09:27:25 +0100
Message-Id: <1396340845-24060-7-git-send-email-ckeepax@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.2.5
In-Reply-To: <1396340845-24060-1-git-send-email-ckeepax@opensource.wolfsonmicro.com>
References: <1396340845-24060-1-git-send-email-ckeepax@opensource.wolfsonmicro.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
---
 Documentation/devicetree/bindings/mfd/arizona.txt |    6 ++++--
 1 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/Documentation/devicetree/bindings/mfd/arizona.txt b/Documentation/devicetree/bindings/mfd/arizona.txt
index aa16489..10f87a29 100644
--- a/Documentation/devicetree/bindings/mfd/arizona.txt
+++ b/Documentation/devicetree/bindings/mfd/arizona.txt
@@ -40,13 +40,15 @@ Optional properties:
     the chip default will be used.  If present exactly five values must
     be specified.
 
-  - DCVDD-supply : Power supply, only needs to be specified if DCVDD is being
-    externally supplied. As covered in
+  - DCVDD-supply, MICVDD-supply : Power supplies, only need to be specified if
+    they are being externally supplied. As covered in
     Documentation/devicetree/bindings/regulator/regulator.txt
 
 Optional subnodes:
   - ldo1 : Initial data for the LDO1 regulator, as covered in
     Documentation/devicetree/bindings/regulator/regulator.txt
+  - micvdd : Initial data for the MICVDD regulator, as covered in
+    Documentation/devicetree/bindings/regulator/regulator.txt
 
 Example:
 
-- 
1.7.2.5

