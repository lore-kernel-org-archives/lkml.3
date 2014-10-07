Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752781AbaJGBt3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Oct 2014 21:49:29 -0400
Received: from regular1.263xmail.com ([211.150.99.137]:59902 "EHLO
	regular1.263xmail.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751482AbaJGBt1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Oct 2014 21:49:27 -0400
X-263anti-spam: KSV:0;
X-MAIL-GRAY: 0
X-MAIL-DELIVERY: 1
X-KSVirus-check: 0
X-ABS-CHECKED: 4
X-RL-SENDER: jay.xu@rock-chips.com
X-FST-TO: robh+dt@kernel.org
X-SENDER-IP: 127.0.0.1
X-LOGIN-NAME: jay.xu@rock-chips.com
X-UNIQUE-TAG: <b122d680c3345574c37e8ed7070e5167>
X-ATTACHMENT-NUM: 0
X-DNS-TYPE: 1
From: Jianqun <jay.xu@rock-chips.com>
To: robh+dt@kernel.org, pawel.moll@arm.com, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org, heiko@sntech.de,
        lgirdwood@gmail.com, broonie@kernel.org, perex@perex.cz, tiwai@suse.de,
        grant.likely@linaro.org, jay.xu@rock-chips.com,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH 2/2] ASoC: rockchip-max98090: add documentation for rockchip-max98090 driver
Date: Tue,  7 Oct 2014 09:47:20 +0800
Message-Id: <1412646440-9503-1-git-send-email-jay.xu@rock-chips.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1412646237-9369-1-git-send-email-jay.xu@rock-chips.com>
References: <1412646237-9369-1-git-send-email-jay.xu@rock-chips.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add documentation for rockchip-max98090 driver, which is need by rockchip
board using a max98090.

Signed-off-by: Jianqun Xu <jay.xu@rock-chips.com>
---
 .../sound/rockchip,rockchip-audio-max98090.txt     | 23 ++++++++++++++++++++++
 1 file changed, 23 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/sound/rockchip,rockchip-audio-max98090.txt

diff --git a/Documentation/devicetree/bindings/sound/rockchip,rockchip-audio-max98090.txt b/Documentation/devicetree/bindings/sound/rockchip,rockchip-audio-max98090.txt
new file mode 100644
index 0000000..e12d1a0
--- /dev/null
+++ b/Documentation/devicetree/bindings/sound/rockchip,rockchip-audio-max98090.txt
@@ -0,0 +1,23 @@
+ROCKCHIP audio complex, with MAX98090 CODEC
+
+Required properties:
+- compatible : must be "rockchip,rockchip-audio-max98090"
+- rockchip,model : the user-visible name of this sound complex
+- rockchip,i2s-controller : The phandle of the rockchip I2S controller
+  that's connected to the CODEC.
+- rockchip,audio-codec : The phandle of the MAX98090 audio codec.
+
+Optional properties:
+- rockchip,hp-det-gpios : The GPIO that detect headphones are plugged in
+- rockchip,mic-det-gpios : The GPIO that detect micphones are plugged in
+
+Example:
+
+sound {
+	compatible = "rockchip,rockchip-audio-max98090";
+	rockchip,model = "ROCKCHIP-I2S";
+	rockchip,i2s-controller = <&i2s>;
+	rockchip,audio-codec = <&max98090>;
+	rockchip,hp-det-gpios = <&gpio6 5 GPIO_ACTIVE_HIGH>;
+	rockchip,mic-det-gpios = <&gpio6 11 GPIO_ACTIVE_HIGH>;
+};
-- 
1.9.1


