Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932528AbaJGTbA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2014 15:31:00 -0400
Received: from mail-pd0-f175.google.com ([209.85.192.175]:39825 "EHLO
	mail-pd0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932453AbaJGT3n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2014 15:29:43 -0400
From: Nicolin Chen <nicoleotsuka@gmail.com>
To: broonie@kernel.org
Cc: robh+dt@kernel.org, pawel.moll@arm.com, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, alsa-devel@alsa-project.org,
        galak@codeaurora.org
Subject: [PATCH 5/8] ASoC: imx-audmux: Add indentation for binding doc to increase readability
Date: Tue,  7 Oct 2014 12:29:08 -0700
Message-Id: <dd4daca4f9ffc8d6995105a89c29ae0a59d54217.1412708790.git.nicoleotsuka@gmail.com>
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
 .../devicetree/bindings/sound/imx-audmux.txt       | 22 ++++++++++++++--------
 1 file changed, 14 insertions(+), 8 deletions(-)

diff --git a/Documentation/devicetree/bindings/sound/imx-audmux.txt b/Documentation/devicetree/bindings/sound/imx-audmux.txt
index f88a00e..b30a737 100644
--- a/Documentation/devicetree/bindings/sound/imx-audmux.txt
+++ b/Documentation/devicetree/bindings/sound/imx-audmux.txt
@@ -1,18 +1,24 @@
 Freescale Digital Audio Mux (AUDMUX) device
 
 Required properties:
-- compatible : "fsl,imx21-audmux" for AUDMUX version firstly used on i.MX21,
-  or "fsl,imx31-audmux" for the version firstly used on i.MX31.
-- reg : Should contain AUDMUX registers location and length
+
+  - compatible		: "fsl,imx21-audmux" for AUDMUX version firstly used
+			  on i.MX21, or "fsl,imx31-audmux" for the version
+			  firstly used on i.MX31.
+
+  - reg			: Should contain AUDMUX registers location and length.
 
 An initial configuration can be setup using child nodes.
 
 Required properties of optional child nodes:
-- fsl,audmux-port : Integer of the audmux port that is configured by this
-  child node.
-- fsl,port-config : List of configuration options for the specific port. For
-  imx31-audmux and above, it is a list of tuples <ptcr pdcr>. For
-  imx21-audmux it is a list of pcr values.
+
+  - fsl,audmux-port	: Integer of the audmux port that is configured by this
+			  child node.
+
+  - fsl,port-config	: List of configuration options for the specific port.
+			  For imx31-audmux and above, it is a list of tuples
+			  <ptcr pdcr>. For imx21-audmux it is a list of pcr
+			  values.
 
 Example:
 
-- 
1.9.1

