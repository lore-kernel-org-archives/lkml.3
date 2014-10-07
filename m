Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932517AbaJGTao (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2014 15:30:44 -0400
Received: from mail-pa0-f45.google.com ([209.85.220.45]:37095 "EHLO
	mail-pa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932457AbaJGT3o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2014 15:29:44 -0400
From: Nicolin Chen <nicoleotsuka@gmail.com>
To: broonie@kernel.org
Cc: robh+dt@kernel.org, pawel.moll@arm.com, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, alsa-devel@alsa-project.org,
        galak@codeaurora.org
Subject: [PATCH 6/8] ASoC: imx-sgtl5000: Add indentation for binding doc to increase readability
Date: Tue,  7 Oct 2014 12:29:09 -0700
Message-Id: <ccd981d75810483c046ba8985a15e548cd9ad70b.1412708790.git.nicoleotsuka@gmail.com>
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
 .../bindings/sound/imx-audio-sgtl5000.txt          | 61 ++++++++++++----------
 1 file changed, 34 insertions(+), 27 deletions(-)

diff --git a/Documentation/devicetree/bindings/sound/imx-audio-sgtl5000.txt b/Documentation/devicetree/bindings/sound/imx-audio-sgtl5000.txt
index e4acdd8..2f89db8 100644
--- a/Documentation/devicetree/bindings/sound/imx-audio-sgtl5000.txt
+++ b/Documentation/devicetree/bindings/sound/imx-audio-sgtl5000.txt
@@ -1,33 +1,40 @@
 Freescale i.MX audio complex with SGTL5000 codec
 
 Required properties:
-- compatible : "fsl,imx-audio-sgtl5000"
-- model : The user-visible name of this sound complex
-- ssi-controller : The phandle of the i.MX SSI controller
-- audio-codec : The phandle of the SGTL5000 audio codec
-- audio-routing : A list of the connections between audio components.
-  Each entry is a pair of strings, the first being the connection's sink,
-  the second being the connection's source. Valid names could be power
-  supplies, SGTL5000 pins, and the jacks on the board:
-
-  Power supplies:
-   * Mic Bias
-
-  SGTL5000 pins:
-   * MIC_IN
-   * LINE_IN
-   * HP_OUT
-   * LINE_OUT
-
-  Board connectors:
-   * Mic Jack
-   * Line In Jack
-   * Headphone Jack
-   * Line Out Jack
-   * Ext Spk
-
-- mux-int-port : The internal port of the i.MX audio muxer (AUDMUX)
-- mux-ext-port : The external port of the i.MX audio muxer
+
+  - compatible		: "fsl,imx-audio-sgtl5000"
+
+  - model		: The user-visible name of this sound complex
+
+  - ssi-controller	: The phandle of the i.MX SSI controller
+
+  - audio-codec		: The phandle of the SGTL5000 audio codec
+
+  - audio-routing	: A list of the connections between audio components.
+			  Each entry is a pair of strings, the first being the
+			  connection's sink, the second being the connection's
+			  source. Valid names could be power supplies, SGTL5000
+			  pins, and the jacks on the board:
+
+			  Power supplies:
+			   * Mic Bias
+
+			  SGTL5000 pins:
+			   * MIC_IN
+			   * LINE_IN
+			   * HP_OUT
+			   * LINE_OUT
+
+			  Board connectors:
+			   * Mic Jack
+			   * Line In Jack
+			   * Headphone Jack
+			   * Line Out Jack
+			   * Ext Spk
+
+  - mux-int-port	: The internal port of the i.MX audio muxer (AUDMUX)
+
+  - mux-ext-port	: The external port of the i.MX audio muxer
 
 Note: The AUDMUX port numbering should start at 1, which is consistent with
 hardware manual.
-- 
1.9.1

