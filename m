Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751594AbaAMGwF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jan 2014 01:52:05 -0500
Received: from co9ehsobe002.messaging.microsoft.com ([207.46.163.25]:39683
	"EHLO co9outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751328AbaAMGvQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jan 2014 01:51:16 -0500
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: 0
X-BigFish: VS0(zzzz1f42h2148h208ch1ee6h1de0h1fdah2073h2146h1202h1e76h2189h1d1ah1d2ah1fc6hzz1de098h8275bh1de097hz2dh2a8h839he5bhf0ah1288h12a5h12a9h12bdh12e5h137ah139eh13b6h1441h1504h1537h162dh1631h1758h1898h18e1h1946h19b5h1ad9h1b0ah1b2fh2222h224fh1fb3h1d0ch1d2eh1d3fh1dfeh1dffh1e23h1fe8h1ff5h2218h2216h226dh22d0h2327h2336h2438h2461h1155h)
From: Xiubo Li <Li.Xiubo@freescale.com>
To: <broonie@kernel.org>, <lgirdwood@gmail.com>
CC: <kuninori.morimoto.gx@renesas.com>, <alsa-devel@alsa-project.org>,
        <linux-kernel@vger.kernel.org>, <devicetree@vger.kernel.org>,
        Xiubo Li <Li.Xiubo@freescale.com>
Subject: [PATCHv2 4/6] ASoC: simple-card: add sound-widgets usage
Date: Mon, 13 Jan 2014 13:53:56 +0800
Message-ID: <1389592438-13761-5-git-send-email-Li.Xiubo@freescale.com>
X-Mailer: git-send-email 1.8.0
In-Reply-To: <1389592438-13761-1-git-send-email-Li.Xiubo@freescale.com>
References: <1389592438-13761-1-git-send-email-Li.Xiubo@freescale.com>
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: freescale.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
X-FOPE-CONNECTOR: Id%0$Dn%FREESCALE.MAIL.ONMICROSOFT.COM$RO%1$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Xiubo Li <Li.Xiubo@freescale.com>
---
 Documentation/devicetree/bindings/sound/simple-card.txt | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/Documentation/devicetree/bindings/sound/simple-card.txt b/Documentation/devicetree/bindings/sound/simple-card.txt
index e9e20ec..01eb2d0 100644
--- a/Documentation/devicetree/bindings/sound/simple-card.txt
+++ b/Documentation/devicetree/bindings/sound/simple-card.txt
@@ -15,6 +15,10 @@ Optional properties:
 					  Each entry is a pair of strings, the first being the
 					  connection's sink, the second being the connection's
 					  source.
+- sound-widgets				: The name of the audio card's off-CODEC widgets. If the
+					  audio card need the off-CODEC widgets, the card driver
+					  should register its widgets with one specified name:
+					  "XXXX", and in dt node the sound-widgets = "XXXX".
 
 Required subnodes:
 
@@ -42,6 +46,7 @@ Example:
 
 sound {
 	compatible = "simple-audio-card";
+	sound-widgets = "widgets"
 	simple-audio-card,format = "left_j";
 	simple-audio-routing =
 		"MIC_IN", "Mic Jack",
-- 
1.8.4


