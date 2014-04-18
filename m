Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751286AbaDRAGg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Apr 2014 20:06:36 -0400
Received: from top.free-electrons.com ([176.31.233.9]:58634 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751082AbaDRAGe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Apr 2014 20:06:34 -0400
From: Alexandre Belloni <alexandre.belloni@free-electrons.com>
To: Mark Brown <broonie@kernel.org>
Cc: Liam Girdwood <lgirdwood@gmail.com>, Jyri Sarha <jsarha@ti.com>,
        alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>
Subject: [PATCH] ASoC: tlv320aic31xx: document that the regulators are mandatory
Date: Fri, 18 Apr 2014 02:06:30 +0200
Message-Id: <1397779590-4128-1-git-send-email-alexandre.belloni@free-electrons.com>
X-Mailer: git-send-email 1.8.3.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The driver will not probe if regulators are not provided. Move the regulator
properties to the required section.

Signed-off-by: Alexandre Belloni <alexandre.belloni@free-electrons.com>
---
 Documentation/devicetree/bindings/sound/tlv320aic31xx.txt | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/Documentation/devicetree/bindings/sound/tlv320aic31xx.txt b/Documentation/devicetree/bindings/sound/tlv320aic31xx.txt
index 74c66dee3e14..eff12be5e789 100644
--- a/Documentation/devicetree/bindings/sound/tlv320aic31xx.txt
+++ b/Documentation/devicetree/bindings/sound/tlv320aic31xx.txt
@@ -13,6 +13,9 @@ Required properties:
     "ti,tlv320aic3111" - TLV320AIC3111 (stereo speaker amp, MiniDSP)
 
 - reg - <int> -  I2C slave address
+- HPVDD-supply, SPRVDD-supply, SPLVDD-supply, AVDD-supply, IOVDD-supply,
+  DVDD-supply : power supplies for the device as covered in
+  Documentation/devicetree/bindings/regulator/regulator.txt
 
 
 Optional properties:
@@ -24,9 +27,6 @@ Optional properties:
         3 or MICBIAS_AVDD - MICBIAS output is connected to AVDD
 	If this node is not mentioned or if the value is unknown, then
 	micbias	is set to 2.0V.
-- HPVDD-supply, SPRVDD-supply, SPLVDD-supply, AVDD-supply, IOVDD-supply,
-  DVDD-supply : power supplies for the device as covered in
-  Documentation/devicetree/bindings/regulator/regulator.txt
 
 CODEC output pins:
   * HPL
-- 
1.8.3.2

