Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751222AbaLOCzz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Dec 2014 21:55:55 -0500
Received: from regular1.263xmail.com ([211.150.99.131]:38026 "EHLO
	regular1.263xmail.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750713AbaLOCzr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Dec 2014 21:55:47 -0500
X-Greylist: delayed 2617 seconds by postgrey-1.27 at vger.kernel.org; Sun, 14 Dec 2014 21:55:45 EST
X-263anti-spam: KSV:0;
X-MAIL-GRAY: 0
X-MAIL-DELIVERY: 1
X-KSVirus-check: 0
X-ABS-CHECKED: 4
X-RL-SENDER: ykk@rock-chips.com
X-FST-TO: ykk@rock-chips.com
X-SENDER-IP: 104.167.231.7
X-LOGIN-NAME: ykk@rock-chips.com
X-UNIQUE-TAG: <710391f6deaf69dd0c538ff36e0284b8>
X-ATTACHMENT-NUM: 0
X-DNS-TYPE: 0
From: Yakir Yang <ykk@rock-chips.com>
To: ykk@rock-chips.com
Cc: Heiko Stuebner <heiko@sntech.de>, Rob Herring <robh+dt@kernel.org>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>,
        Philipp Zabel <p.zabel@pengutronix.de>, Zubair.Kakakhel@imgtec.com,
        Fabio Estevam <fabio.estevam@freescale.com>,
        Shawn Guo <shawn.guo@linaro.org>, dri-devel@lists.freedesktop.org,
        Daniel Kurtz <djkurtz@chromium.org>, Sonny Rao <sonnyrao@chromium.org>,
        Dylan Reid <dgreid@chromium.org>, Xu Jianqun <jay.xu@rock-chips.com>,
        =?UTF-8?q?St=A8=A6phane=20Marchesin?= <marcheu@chromium.org>,
        Lars-Peter Clausen <lars@metafoo.de>,
        Brian Austin <brian.austin@cirrus.com>,
        Bard Liao <bardliao@realtek.com>, Max Filippov <jcmvbkbc@gmail.com>,
        Oder Chiou <oder_chiou@realtek.com>, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-rockchip@lists.infradead.org, alsa-devel@alsa-project.org,
        Arnd Bergmann <arnd@arndb.de>, David Airlie <airlied@linux.ie>,
        Sean Cross <xobs@kosagi.com>, Grant Likely <grant.likely@linaro.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Ben Zhang <benzh@chromium.org>, Liam Girdwood <lgirdwood@gmail.com>,
        Jaroslav Kysela <perex@perex.cz>, Mark Brown <broonie@kernel.org>,
        Takashi Iwai <tiwai@suse.de>, Jyri Sarha <jsarha@ti.com>
Subject: [PATCH 5/6] dt-bindings: Add documentation for Rockchip hdmi-audio
Date: Mon, 15 Dec 2014 10:55:14 +0800
Message-Id: <1418612114-19692-1-git-send-email-ykk@rock-chips.com>
X-Mailer: git-send-email 2.1.2
In-Reply-To: <1418609494-15820-1-git-send-email-ykk@rock-chips.com>
References: <1418609494-15820-1-git-send-email-ykk@rock-chips.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Required properties:
- compatible: platform specific
- cpu-of-node: the device node of cpu_dai
- codec-name: the dw-hdmi codec's device name
- codec-dai-name: the dw-hdmi codec's dai name

Signed-off-by: Yakir Yang <ykk@rock-chips.com>
---

 .../bindings/sound/rockchip,rockchip-hdmi-audio.txt      | 16 ++++++++++++++++
 1 file changed, 16 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/sound/rockchip,rockchip-hdmi-audio.txt

diff --git a/Documentation/devicetree/bindings/sound/rockchip,rockchip-hdmi-audio.txt b/Documentation/devicetree/bindings/sound/rockchip,rockchip-hdmi-audio.txt
new file mode 100644
index 0000000..674cff0
--- /dev/null
+++ b/Documentation/devicetree/bindings/sound/rockchip,rockchip-hdmi-audio.txt
@@ -0,0 +1,16 @@
+Rockchip hdmi audio bindings
+
+Required properties:
+- compatible: platform specific
+- cpu-of-node: the device node of cpu_dai
+- codec-name: the dw-hdmi codec's device name
+- codec-dai-name: the dw-hdmi codec's dai name
+
+Example:
+
+sound {
+	compatible = "rockchip,rk3288-hdmi-audio";
+	cpu-of-node = <&i2s>;
+	codec-name = "dw-hdmi-audio";
+	codec-dai-name = "dw-hdmi-hifi";
+};
-- 
2.1.2


