Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755267AbaDPJNR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2014 05:13:17 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:58360 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755174AbaDPJJs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2014 05:09:48 -0400
From: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
To: broonie@kernel.org
Cc: lgirdwood@gmail.com, robh+dt@kernel.org, pawel.moll@arm.com,
        mark.rutland@arm.com, ijc+devicetree@hellion.org.uk,
        galak@codeaurora.org, rdunlap@infradead.org, sameo@linux.intel.com,
        lee.jones@linaro.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, ckeepax@opensource.wolfsonmicro.com
Subject: [PATCH 4/6] mfd: arizona: Update DT binding to support LDO1 init_data
Date: Wed, 16 Apr 2014 10:01:40 +0100
Message-Id: <1397638902-7576-5-git-send-email-ckeepax@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.2.5
In-Reply-To: <1397638902-7576-1-git-send-email-ckeepax@opensource.wolfsonmicro.com>
References: <1397638902-7576-1-git-send-email-ckeepax@opensource.wolfsonmicro.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
---
 Documentation/devicetree/bindings/mfd/arizona.txt |    8 ++++++++
 1 files changed, 8 insertions(+), 0 deletions(-)

diff --git a/Documentation/devicetree/bindings/mfd/arizona.txt b/Documentation/devicetree/bindings/mfd/arizona.txt
index 36a0c3d..fd51988 100644
--- a/Documentation/devicetree/bindings/mfd/arizona.txt
+++ b/Documentation/devicetree/bindings/mfd/arizona.txt
@@ -42,6 +42,14 @@ Optional properties:
     the chip default will be used.  If present exactly five values must
     be specified.
 
+  - DCVDD-supply : Power supply, only needs to be specified if DCVDD is being
+    externally supplied. As covered in
+    Documentation/devicetree/bindings/regulator/regulator.txt
+
+Optional subnodes:
+  - ldo1 : Initial data for the LDO1 regulator, as covered in
+    Documentation/devicetree/bindings/regulator/regulator.txt
+
 Example:
 
 codec: wm5102@1a {
-- 
1.7.2.5

