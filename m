Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753542AbaCaMK5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Mar 2014 08:10:57 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:45843 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752633AbaCaMIo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Mar 2014 08:08:44 -0400
From: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
To: broonie@kernel.org
Cc: lee.jones@linaro.org, robh+dt@kernel.org, pawel.moll@arm.com,
        mark.rutland@arm.com, ijc+devicetree@hellion.org.uk,
        galak@codeaurora.org, rob@landley.net, sameo@linux.intel.com,
        lgirdwood@gmail.com, ckeepax@opensource.wolfsonmicro.com,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 6/6] mfd: arizona: Update DT binding to support MICVDD init_data
Date: Mon, 31 Mar 2014 12:59:47 +0100
Message-Id: <1396267187-30580-7-git-send-email-ckeepax@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.2.5
In-Reply-To: <1396267187-30580-1-git-send-email-ckeepax@opensource.wolfsonmicro.com>
References: <1396267187-30580-1-git-send-email-ckeepax@opensource.wolfsonmicro.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
---
 Documentation/devicetree/bindings/mfd/arizona.txt |    6 ++++--
 1 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/Documentation/devicetree/bindings/mfd/arizona.txt b/Documentation/devicetree/bindings/mfd/arizona.txt
index c019e73..0bf69a9 100644
--- a/Documentation/devicetree/bindings/mfd/arizona.txt
+++ b/Documentation/devicetree/bindings/mfd/arizona.txt
@@ -42,9 +42,11 @@ Optional properties:
 
   - ldo1 : Initial data for the LDO1 regulator, as covered in
     Documentation/devicetree/bindings/regulator/regulator.txt
+  - micvdd : Initial data for the MICVDD regulator, as covered in
+    Documentation/devicetree/bindings/regulator/regulator.txt
 
-  - DCVDD-supply : Power supply, only needs to be specified if DCVDD is being
-    externally supplied. As covered in
+  - DCVDD-supply, MICVDD-supply : Power supplies, only need to be specified if
+    they are being externally supplied. As covered in
     Documentation/devicetree/bindings/regulator/regulator.txt
 
 Example:
-- 
1.7.2.5

