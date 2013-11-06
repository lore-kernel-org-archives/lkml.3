Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932333Ab3KFKTK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Nov 2013 05:19:10 -0500
Received: from mail-ie0-f171.google.com ([209.85.223.171]:35309 "EHLO
	mail-ie0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932146Ab3KFKQ6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Nov 2013 05:16:58 -0500
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: linus.walleij@linaro.org, Lee Jones <lee.jones@linaro.org>,
        devicetree@vger.kernel.org, Mark Brown <broonie@kernel.org>
Subject: [PATCH 06/13] ASoC: ux500_pcm: Extend ux500 MSP binding for enumeration
Date: Wed,  6 Nov 2013 10:16:18 +0000
Message-Id: <1383732985-18928-7-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1383732985-18928-1-git-send-email-lee.jones@linaro.org>
References: <1383732985-18928-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cc: devicetree@vger.kernel.org
Cc: Mark Brown <broonie@kernel.org>
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 Documentation/devicetree/bindings/sound/ux500-msp.txt | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/Documentation/devicetree/bindings/sound/ux500-msp.txt b/Documentation/devicetree/bindings/sound/ux500-msp.txt
index 99acd9c..33bd000 100644
--- a/Documentation/devicetree/bindings/sound/ux500-msp.txt
+++ b/Documentation/devicetree/bindings/sound/ux500-msp.txt
@@ -3,6 +3,7 @@
 Required properties:
  - compatible       :"stericsson,ux500-msp-i2s"
  - reg              : Physical base address and length of the device's registers.
+ - id               : MSP ID - used during component registration
 
 Optional properties:
  - interrupts       : The interrupt output from the device.
@@ -28,6 +29,7 @@ Example:
 		reg = <0x80124000 0x1000>;
 		interrupts = <0 62 0x4>;
 		v-ape-supply = <&db8500_vape_reg>;
+		id = <1>;
 	};
 
 	msp3: msp@80125000 {
@@ -35,6 +37,7 @@ Example:
 		reg = <0x80125000 0x1000>;
 		interrupts = <0 62 0x4>;
 		v-ape-supply = <&db8500_vape_reg>;
+		id = <3>;
 	};
 
 	codec: ab8500-codec {
-- 
1.8.1.2

