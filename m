Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932474AbaJGT3p (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2014 15:29:45 -0400
Received: from mail-pa0-f47.google.com ([209.85.220.47]:48618 "EHLO
	mail-pa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932401AbaJGT3m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2014 15:29:42 -0400
From: Nicolin Chen <nicoleotsuka@gmail.com>
To: broonie@kernel.org
Cc: robh+dt@kernel.org, pawel.moll@arm.com, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, alsa-devel@alsa-project.org,
        galak@codeaurora.org
Subject: [PATCH 4/8] ASoC: eukrea-tlv320: Add indentation for binding doc to increase readability
Date: Tue,  7 Oct 2014 12:29:07 -0700
Message-Id: <54aeea0c484b42125e10c54056b3b7f2b67b14d6.1412708790.git.nicoleotsuka@gmail.com>
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
 Documentation/devicetree/bindings/sound/eukrea-tlv320.txt | 15 ++++++++++-----
 1 file changed, 10 insertions(+), 5 deletions(-)

diff --git a/Documentation/devicetree/bindings/sound/eukrea-tlv320.txt b/Documentation/devicetree/bindings/sound/eukrea-tlv320.txt
index 0d7985c..6dfa88c 100644
--- a/Documentation/devicetree/bindings/sound/eukrea-tlv320.txt
+++ b/Documentation/devicetree/bindings/sound/eukrea-tlv320.txt
@@ -1,11 +1,16 @@
 Audio complex for Eukrea boards with tlv320aic23 codec.
 
 Required properties:
-- compatible : "eukrea,asoc-tlv320"
-- eukrea,model : The user-visible name of this sound complex.
-- ssi-controller : The phandle of the SSI controller.
-- fsl,mux-int-port : The internal port of the i.MX audio muxer (AUDMUX).
-- fsl,mux-ext-port : The external port of the i.MX audio muxer.
+
+  - compatible		: "eukrea,asoc-tlv320"
+
+  - eukrea,model	: The user-visible name of this sound complex.
+
+  - ssi-controller	: The phandle of the SSI controller.
+
+  - fsl,mux-int-port	: The internal port of the i.MX audio muxer (AUDMUX).
+
+  - fsl,mux-ext-port	: The external port of the i.MX audio muxer.
 
 Note: The AUDMUX port numbering should start at 1, which is consistent with
 hardware manual.
-- 
1.9.1

