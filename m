Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751740AbaBHJFt (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Feb 2014 04:05:49 -0500
Received: from [216.32.180.14] ([216.32.180.14]:38533 "EHLO
	va3outboundpool.messaging.microsoft.com" rhost-flags-FAIL-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751700AbaBHJFi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Feb 2014 04:05:38 -0500
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: 0
X-BigFish: VS0(zzzz1f42h2148h208ch1ee6h1de0h1fdah2073h2146h1202h1e76h2189h1d1ah1d2ah21bch1fc6hzdchz1de098h8275bh8275dh1de097hz2dh2a8h839he5bhf0ah1288h12a5h12a9h12bdh12e5h137ah139eh13b6h1441h1504h1537h162dh1631h1758h1898h18e1h1946h19b5h1ad9h1b0ah1b2fh2222h224fh1fb3h1d0ch1d2eh1d3fh1dfeh1dffh1e23h1fe8h1ff5h2218h2216h226dh22d0h24afh2327h2336h2438h2461h2487h24d7h2516h2545h1155h)
From: Xiubo Li <Li.Xiubo@freescale.com>
To: <broonie@kernel.org>, <lgirdwood@gmail.com>,
        <kuninori.morimoto.gx@renesas.com>
CC: <perex@perex.cz>, <tiwai@suse.de>, <linux-kernel@vger.kernel.org>,
        <alsa-devel@alsa-project.org>, Xiubo Li <Li.Xiubo@freescale.com>
Subject: [PATCH v3 3/4] ASoC: binding: add widgets.txt
Date: Sat, 8 Feb 2014 15:59:54 +0800
Message-ID: <1391846395-10193-4-git-send-email-Li.Xiubo@freescale.com>
X-Mailer: git-send-email 1.8.0
In-Reply-To: <1391846395-10193-1-git-send-email-Li.Xiubo@freescale.com>
References: <1391846395-10193-1-git-send-email-Li.Xiubo@freescale.com>
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: freescale.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
X-FOPE-CONNECTOR: Id%0$Dn%FREESCALE.MAIL.ONMICROSOFT.COM$RO%1$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Suggested-by: Mark Brown <broonie@linaro.org>
Signed-off-by: Xiubo Li <Li.Xiubo@freescale.com>
---
 Documentation/devicetree/bindings/sound/widgets.txt | 20 ++++++++++++++++++++
 1 file changed, 20 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/sound/widgets.txt

diff --git a/Documentation/devicetree/bindings/sound/widgets.txt b/Documentation/devicetree/bindings/sound/widgets.txt
new file mode 100644
index 0000000..b6de5ba
--- /dev/null
+++ b/Documentation/devicetree/bindings/sound/widgets.txt
@@ -0,0 +1,20 @@
+Widgets:
+
+This mainly specifies audio off-codec DAPM widgets.
+
+Each entry is a pair of strings in DT:
+
+	"template-wname", "user-supplied-wname"
+
+The "template-wname" being the template widget name and currently includes:
+"Microphone", "Line", "Headphone" and "Speaker".
+
+The "user-supplied-wname" being the user specified widget name.
+
+For instance:
+	simple-audio-widgets =
+		"Microphone", "Microphone Jack",
+		"Line", "Line In Jack",
+		"Line", "Line Out Jack",
+		"Headphone", "Headphone Jack",
+		"Speaker", "Speaker External";
-- 
1.8.4


