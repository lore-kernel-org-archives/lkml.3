Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755159AbaJGTbs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2014 15:31:48 -0400
Received: from mail-pd0-f169.google.com ([209.85.192.169]:65257 "EHLO
	mail-pd0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932407AbaJGT3e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2014 15:29:34 -0400
From: Nicolin Chen <nicoleotsuka@gmail.com>
To: broonie@kernel.org
Cc: robh+dt@kernel.org, pawel.moll@arm.com, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, alsa-devel@alsa-project.org,
        galak@codeaurora.org
Subject: [PATCH 1/8] ASoC: fsl_esai: Add indentation for binding doc to increase readability
Date: Tue,  7 Oct 2014 12:29:04 -0700
Message-Id: <4695fdade8e76d91b7647471590bc96d970d15a9.1412708790.git.nicoleotsuka@gmail.com>
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
 .../devicetree/bindings/sound/fsl,esai.txt         | 44 +++++++++++-----------
 1 file changed, 23 insertions(+), 21 deletions(-)

diff --git a/Documentation/devicetree/bindings/sound/fsl,esai.txt b/Documentation/devicetree/bindings/sound/fsl,esai.txt
index 52f5b6b..d3b6b5f 100644
--- a/Documentation/devicetree/bindings/sound/fsl,esai.txt
+++ b/Documentation/devicetree/bindings/sound/fsl,esai.txt
@@ -7,37 +7,39 @@ other DSPs. It has up to six transmitters and four receivers.
 
 Required properties:
 
-  - compatible : Compatible list, must contain "fsl,imx35-esai" or
-		 "fsl,vf610-esai"
+  - compatible		: Compatible list, must contain "fsl,imx35-esai" or
+			  "fsl,vf610-esai"
 
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
 
-  - clocks: Contains an entry for each entry in clock-names.
+  - clocks		: Contains an entry for each entry in clock-names.
 
-  - clock-names : Includes the following entries:
-	"core"		The core clock used to access registers
-	"extal"		The esai baud clock for esai controller used to derive
-			HCK, SCK and FS.
-	"fsys"		The system clock derived from ahb clock used to derive
-			HCK, SCK and FS.
+  - clock-names		: Includes the following entries:
+	"core"		  The core clock used to access registers
+	"extal"		  The esai baud clock for esai controller used to
+			  derive HCK, SCK and FS.
+	"fsys"		  The system clock derived from ahb clock used to
+			  derive HCK, SCK and FS.
 
-  - fsl,fifo-depth: The number of elements in the transmit and receive FIFOs.
-    This number is the maximum allowed value for TFCR[TFWM] or RFCR[RFWM].
+  - fsl,fifo-depth	: The number of elements in the transmit and receive
+			  FIFOs. This number is the maximum allowed value for
+			  TFCR[TFWM] or RFCR[RFWM].
 
   - fsl,esai-synchronous: This is a boolean property. If present, indicating
-    that ESAI would work in the synchronous mode, which means all the settings
-    for Receiving would be duplicated from Transmition related registers.
+			  that ESAI would work in the synchronous mode, which
+			  means all the settings for Receiving would be
+			  duplicated from Transmition related registers.
 
-  - big-endian : If this property is absent, the native endian mode will
-    be in use as default, or the big endian mode will be in use for all the
-    device registers.
+  - big-endian		: If this property is absent, the native endian mode
+			  will be in use as default, or the big endian mode
+			  will be in use for all the device registers.
 
 Example:
 
-- 
1.9.1

