Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755738AbbAZKSu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2015 05:18:50 -0500
Received: from mailapp01.imgtec.com ([195.59.15.196]:29437 "EHLO
	mailapp01.imgtec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755631AbbAZKSl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2015 05:18:41 -0500
From: Zubair Lutfullah Kakakhel <Zubair.Kakakhel@imgtec.com>
To: <tiwai@suse.de>, <perex@perex.cz>
CC: <broonie@kernel.org>, <lgirdwood@gmail.com>,
        <linux-kernel@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <alsa-devel@alsa-project.org>, <Zubair.Kakakhel@imgtec.com>
Subject: [PATCH 2/4] dt: sound: jz4740: Add binding documentation for jz4740-i2s
Date: Mon, 26 Jan 2015 10:18:29 +0000
Message-ID: <1422267511-6649-3-git-send-email-Zubair.Kakakhel@imgtec.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1422267511-6649-1-git-send-email-Zubair.Kakakhel@imgtec.com>
References: <1422267511-6649-1-git-send-email-Zubair.Kakakhel@imgtec.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [192.168.154.89]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds binding for the jz4740-i2s driver.

Signed-off-by: Zubair Lutfullah Kakakhel <Zubair.Kakakhel@imgtec.com>

---
The jz4740 is platform only at the moment.

But DT support is being added

See http://patchwork.linux-mips.org/bundle/paulburton/ci20-v3.20/
---
 .../devicetree/bindings/sound/ingenic,jz4740-i2s.txt   | 18 ++++++++++++++++++
 1 file changed, 18 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/sound/ingenic,jz4740-i2s.txt

diff --git a/Documentation/devicetree/bindings/sound/ingenic,jz4740-i2s.txt b/Documentation/devicetree/bindings/sound/ingenic,jz4740-i2s.txt
new file mode 100644
index 0000000..0e40517
--- /dev/null
+++ b/Documentation/devicetree/bindings/sound/ingenic,jz4740-i2s.txt
@@ -0,0 +1,18 @@
+Ingenic JZ4740 I2S controller
+
+Required properties:
+- compatible : "ingenic,jz4740-i2s"
+- reg : I2S registers location and length
+- clocks : AIC and I2S PLL clock specifiers.
+- clock-names: "aic" and "i2s"
+
+Example:
+
+i2s: i2s@10020000 {
+	compatible = "ingenic,jz4740-i2s";
+	reg = <0x10020000 0x94>;
+
+	clocks = <&cgu JZ4740_CLK_AIC>, <&cgu JZ4740_CLK_I2SPLL>;
+	clock-names = "aic", "i2s";
+
+};
-- 
1.9.1

