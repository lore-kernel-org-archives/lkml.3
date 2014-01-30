Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753218AbaA3MEu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jan 2014 07:04:50 -0500
Received: from smtp1-g21.free.fr ([212.27.42.1]:52975 "EHLO smtp1-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753184AbaA3MEt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jan 2014 07:04:49 -0500
X-Mailbox-Line: From 5c20133f084ba9e41c00120b8a7c8d5ed8a23ffa Mon Sep 17 00:00:00 2001
Message-Id: <5c20133f084ba9e41c00120b8a7c8d5ed8a23ffa.1391081934.git.moinejf@free.fr>
In-Reply-To: <cover.1391081933.git.moinejf@free.fr>
References: <cover.1391081933.git.moinejf@free.fr>
From: Jean-Francois Moine <moinejf@free.fr>
Date: Thu, 30 Jan 2014 11:32:48 +0100
Subject: [PATCH v2 3/5] ASoC: tda998x: add DT documentation
To: alsa-devel@alsa-project.org, devicetree@vger.kernel.org
Cc: broonie@kernel.org, Dave Airlie <airlied@gmail.com>,
        dri-devel@lists.freedesktop.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, Rob Clark <robdclark@gmail.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds the DT documentation of the NXP TDA998x CODEC.

Signed-off-by: Jean-Francois Moine <moinejf@free.fr>
---
 Documentation/devicetree/bindings/sound/tda998x.txt | 16 ++++++++++++++++
 1 file changed, 16 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/sound/tda998x.txt

diff --git a/Documentation/devicetree/bindings/sound/tda998x.txt b/Documentation/devicetree/bindings/sound/tda998x.txt
new file mode 100644
index 0000000..13b73ca
--- /dev/null
+++ b/Documentation/devicetree/bindings/sound/tda998x.txt
@@ -0,0 +1,16 @@
+Device-Tree bindings for the NXP TDA998x HDMI transmitter
+
+Required properties:
+	- compatible: must be "nxp,tda998x-codec".
+	- audio-ports: one or two values corresponding to entries in
+		the audio-port-names property.
+	- audio-port-names: must contain "i2s", "spdif" entries
+		matching entries in the audio-ports property.
+
+Example node:
+
+	hdmi_codec: hdmi-codec {
+		compatible = "nxp,tda998x-codec";
+		audio-ports = <0x03>, <0x04>;
+		audio-port-names = "i2s", "spdif";
+	};
-- 
1.9.rc1

