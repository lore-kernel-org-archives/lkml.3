Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755008AbaJGTbr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2014 15:31:47 -0400
Received: from mail-pd0-f169.google.com ([209.85.192.169]:58131 "EHLO
	mail-pd0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932408AbaJGT3f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2014 15:29:35 -0400
From: Nicolin Chen <nicoleotsuka@gmail.com>
To: broonie@kernel.org
Cc: robh+dt@kernel.org, pawel.moll@arm.com, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, alsa-devel@alsa-project.org,
        galak@codeaurora.org
Subject: [PATCH 2/8] ASoC: fsl_spdif: Add indentation for binding doc to increase readability
Date: Tue,  7 Oct 2014 12:29:05 -0700
Message-Id: <b2f1493f287141c01f6db5aae23e084730c02b49.1412708790.git.nicoleotsuka@gmail.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <cover.1412708790.git.nicoleotsuka@gmail.com>
References: <cover.1412708790.git.nicoleotsuka@gmail.com>
In-Reply-To: <cover.1412708790.git.nicoleotsuka@gmail.com>
References: <cover.1412708790.git.nicoleotsuka@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch simply adds indentations for DT binding doc to increase readability
without changing any contents.

Signed-off-by: Nicolin Chen <nicoleotsuka@gmail.com>
---
 .../devicetree/bindings/sound/fsl,spdif.txt        | 37 +++++++++++-----------
 1 file changed, 18 insertions(+), 19 deletions(-)

diff --git a/Documentation/devicetree/bindings/sound/fsl,spdif.txt b/Documentation/devicetree/bindings/sound/fsl,spdif.txt
index 3e9e82c8..b5ee32e 100644
--- a/Documentation/devicetree/bindings/sound/fsl,spdif.txt
+++ b/Documentation/devicetree/bindings/sound/fsl,spdif.txt
@@ -6,32 +6,31 @@ a fibre cable.
 
 Required properties:
 
-  - compatible : Compatible list, must contain "fsl,imx35-spdif".
+  - compatible		: Compatible list, must contain "fsl,imx35-spdif".
 
-  - reg : Offset and length of the register set for the device.
+  - reg			: Offset and length of the register set for the device.
 
-  - interrupts : Contains the spdif interrupt.
+  - interrupts		: Contains the spdif interrupt.
 
-  - dmas : Generic dma devicetree binding as described in
-  Documentation/devicetree/bindings/dma/dma.txt.
+  - dmas		: Generic dma devicetree binding as described in
+			  Documentation/devicetree/bindings/dma/dma.txt.
 
-  - dma-names : Two dmas have to be defined, "tx" and "rx".
+  - dma-names		: Two dmas have to be defined, "tx" and "rx".
 
-  - clocks : Contains an entry for each entry in clock-names.
+  - clocks		: Contains an entry for each entry in clock-names.
 
-  - clock-names : Includes the following entries:
-	"core"		The core clock of spdif controller
-	"rxtx<0-7>"	Clock source list for tx and rx clock.
-			This clock list should be identical to
-			the source list connecting to the spdif
-			clock mux in "SPDIF Transceiver Clock
-			Diagram" of SoC reference manual. It
-			can also be referred to TxClk_Source
-			bit of register SPDIF_STC.
+  - clock-names		: Includes the following entries:
+	"core"		  The core clock of spdif controller.
+	"rxtx<0-7>"	  Clock source list for tx and rx clock.
+			  This clock list should be identical to the source
+			  list connecting to the spdif clock mux in "SPDIF
+			  Transceiver Clock Diagram" of SoC reference manual.
+			  It can also be referred to TxClk_Source bit of
+			  register SPDIF_STC.
 
-   - big-endian : If this property is absent, the native endian mode will
-   be in use as default, or the big endian mode will be in use for all the
-   device registers.
+   - big-endian		: If this property is absent, the native endian mode
+			  will be in use as default, or the big endian mode
+			  will be in use for all the device registers.
 
 Example:
 
-- 
1.9.1

