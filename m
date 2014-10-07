Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932447AbaJGT3k (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2014 15:29:40 -0400
Received: from mail-pd0-f179.google.com ([209.85.192.179]:43889 "EHLO
	mail-pd0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932421AbaJGT3h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2014 15:29:37 -0400
From: Nicolin Chen <nicoleotsuka@gmail.com>
To: broonie@kernel.org
Cc: robh+dt@kernel.org, pawel.moll@arm.com, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, alsa-devel@alsa-project.org,
        galak@codeaurora.org
Subject: [PATCH 3/8] ASoC: fsl_sai: Add indentation for binding doc to increase readability
Date: Tue,  7 Oct 2014 12:29:06 -0700
Message-Id: <50d58e1906b2e3e8b9f5fded5758c69f5ca39bbc.1412708790.git.nicoleotsuka@gmail.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <cover.1412708790.git.nicoleotsuka@gmail.com>
References: <cover.1412708790.git.nicoleotsuka@gmail.com>
In-Reply-To: <cover.1412708790.git.nicoleotsuka@gmail.com>
References: <cover.1412708790.git.nicoleotsuka@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch refines the DT binding doc for more readability by adding
extra blank lines and indentations.

Signed-off-by: Nicolin Chen <nicoleotsuka@gmail.com>
---
 .../devicetree/bindings/sound/fsl-sai.txt          | 66 ++++++++++++++--------
 1 file changed, 41 insertions(+), 25 deletions(-)

diff --git a/Documentation/devicetree/bindings/sound/fsl-sai.txt b/Documentation/devicetree/bindings/sound/fsl-sai.txt
index 4956b14..044e5d7 100644
--- a/Documentation/devicetree/bindings/sound/fsl-sai.txt
+++ b/Documentation/devicetree/bindings/sound/fsl-sai.txt
@@ -5,32 +5,48 @@ which provides a synchronous audio interface that supports fullduplex
 serial interfaces with frame synchronization such as I2S, AC97, TDM, and
 codec/DSP interfaces.
 
-
 Required properties:
-- compatible: Compatible list, contains "fsl,vf610-sai" or "fsl,imx6sx-sai".
-- reg: Offset and length of the register set for the device.
-- clocks: Must contain an entry for each entry in clock-names.
-- clock-names : Must include the "bus" for register access and "mclk1" "mclk2"
-  "mclk3" for bit clock and frame clock providing.
-- dmas : Generic dma devicetree binding as described in
-  Documentation/devicetree/bindings/dma/dma.txt.
-- dma-names : Two dmas have to be defined, "tx" and "rx".
-- pinctrl-names: Must contain a "default" entry.
-- pinctrl-NNN: One property must exist for each entry in pinctrl-names.
-  See ../pinctrl/pinctrl-bindings.txt for details of the property values.
-- big-endian: Boolean property, required if all the FTM_PWM registers
-  are big-endian rather than little-endian.
-- lsb-first: Configures whether the LSB or the MSB is transmitted first for
-  the fifo data. If this property is absent, the MSB is transmitted first as
-  default, or the LSB is transmitted first.
-- fsl,sai-synchronous-rx: This is a boolean property. If present, indicating
-  that SAI will work in the synchronous mode (sync Tx with Rx) which means
-  both the transimitter and receiver will send and receive data by following
-  receiver's bit clocks and frame sync clocks.
-- fsl,sai-asynchronous: This is a boolean property. If present, indicating
-  that SAI will work in the asynchronous mode, which means both transimitter
-  and receiver will send and receive data by following their own bit clocks
-  and frame sync clocks separately.
+
+  - compatible		: Compatible list, contains "fsl,vf610-sai" or
+			  "fsl,imx6sx-sai".
+
+  - reg			: Offset and length of the register set for the device.
+
+  - clocks		: Must contain an entry for each entry in clock-names.
+
+  - clock-names		: Must include the "bus" for register access and
+			  "mclk1", "mclk2", "mclk3" for bit clock and frame
+			  clock providing.
+  - dmas		: Generic dma devicetree binding as described in
+			  Documentation/devicetree/bindings/dma/dma.txt.
+
+  - dma-names		: Two dmas have to be defined, "tx" and "rx".
+
+  - pinctrl-names	: Must contain a "default" entry.
+
+  - pinctrl-NNN		: One property must exist for each entry in
+			  pinctrl-names. See ../pinctrl/pinctrl-bindings.txt
+			  for details of the property values.
+
+  - big-endian		: Boolean property, required if all the FTM_PWM
+			  registers are big-endian rather than little-endian.
+
+  - lsb-first		: Configures whether the LSB or the MSB is transmitted
+			  first for the fifo data. If this property is absent,
+			  the MSB is transmitted first as default, or the LSB
+			  is transmitted first.
+
+  - fsl,sai-synchronous-rx: This is a boolean property. If present, indicating
+			  that SAI will work in the synchronous mode (sync Tx
+			  with Rx) which means both the transimitter and the
+			  receiver will send and receive data by following
+			  receiver's bit clocks and frame sync clocks.
+
+  - fsl,sai-asynchronous: This is a boolean property. If present, indicating
+			  that SAI will work in the asynchronous mode, which
+			  means both transimitter and receiver will send and
+			  receive data by following their own bit clocks and
+			  frame sync clocks separately.
 
 Note:
 - If both fsl,sai-asynchronous and fsl,sai-synchronous-rx are absent, the
-- 
1.9.1

