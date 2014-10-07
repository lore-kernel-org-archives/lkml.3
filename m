Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932505AbaJGTaG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2014 15:30:06 -0400
Received: from mail-pa0-f45.google.com ([209.85.220.45]:33062 "EHLO
	mail-pa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932197AbaJGT3r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2014 15:29:47 -0400
From: Nicolin Chen <nicoleotsuka@gmail.com>
To: broonie@kernel.org
Cc: robh+dt@kernel.org, pawel.moll@arm.com, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, alsa-devel@alsa-project.org,
        galak@codeaurora.org
Subject: [PATCH 8/8] ASoC: imx-wm8962: Add indentation for binding doc to increase readability
Date: Tue,  7 Oct 2014 12:29:11 -0700
Message-Id: <e1d8d13b0417f4e6ce4ef0fbac80503ba1899e29.1412708790.git.nicoleotsuka@gmail.com>
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
 .../devicetree/bindings/sound/imx-audio-wm8962.txt | 45 +++++++++++++---------
 1 file changed, 26 insertions(+), 19 deletions(-)

diff --git a/Documentation/devicetree/bindings/sound/imx-audio-wm8962.txt b/Documentation/devicetree/bindings/sound/imx-audio-wm8962.txt
index f49450a..acea71b 100644
--- a/Documentation/devicetree/bindings/sound/imx-audio-wm8962.txt
+++ b/Documentation/devicetree/bindings/sound/imx-audio-wm8962.txt
@@ -1,25 +1,32 @@
 Freescale i.MX audio complex with WM8962 codec
 
 Required properties:
-- compatible : "fsl,imx-audio-wm8962"
-- model : The user-visible name of this sound complex
-- ssi-controller : The phandle of the i.MX SSI controller
-- audio-codec : The phandle of the WM8962 audio codec
-- audio-routing : A list of the connections between audio components.
-  Each entry is a pair of strings, the first being the connection's sink,
-  the second being the connection's source. Valid names could be power
-  supplies, WM8962 pins, and the jacks on the board:
-
-  Power supplies:
-   * Mic Bias
-
-  Board connectors:
-   * Mic Jack
-   * Headphone Jack
-   * Ext Spk
-
-- mux-int-port : The internal port of the i.MX audio muxer (AUDMUX)
-- mux-ext-port : The external port of the i.MX audio muxer
+
+  - compatible		: "fsl,imx-audio-wm8962"
+
+  - model		: The user-visible name of this sound complex
+
+  - ssi-controller	: The phandle of the i.MX SSI controller
+
+  - audio-codec		: The phandle of the WM8962 audio codec
+
+  - audio-routing	: A list of the connections between audio components.
+			  Each entry is a pair of strings, the first being the
+			  connection's sink, the second being the connection's
+			  source. Valid names could be power supplies, WM8962
+			  pins, and the jacks on the board:
+
+			  Power supplies:
+			   * Mic Bias
+
+			  Board connectors:
+			   * Mic Jack
+			   * Headphone Jack
+			   * Ext Spk
+
+  - mux-int-port	: The internal port of the i.MX audio muxer (AUDMUX)
+
+  - mux-ext-port	: The external port of the i.MX audio muxer
 
 Note: The AUDMUX port numbering should start at 1, which is consistent with
 hardware manual.
-- 
1.9.1

