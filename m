Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752274AbaAJGOf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jan 2014 01:14:35 -0500
Received: from mail-db9lp0248.outbound.messaging.microsoft.com ([213.199.154.248]:23201
	"EHLO db9outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750793AbaAJGOd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jan 2014 01:14:33 -0500
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: 0
X-BigFish: VS0(zzzz1f42h2148h208ch1ee6h1de0h1fdah2073h2146h1202h1e76h2189h1d1ah1d2ah1fc6hzz1de098h8275bh1de097hz2dh2a8h839he5bhf0ah1288h12a5h12a9h12bdh12e5h137ah139eh13b6h1441h1504h1537h162dh1631h1758h1898h18e1h1946h19b5h1ad9h1b0ah1b2fh2222h224fh1fb3h1d0ch1d2eh1d3fh1dc1h1dfeh1dffh1e23h1fe8h1ff5h2218h2216h226dh22d0h2327h2336h2438h1155h)
From: Xiubo Li <Li.Xiubo@freescale.com>
To: <broonie@linaro.org>
CC: <alsa-devel@alsa-project.org>, <linux-doc@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, Xiubo Li <Li.Xiubo@freescale.com>
Subject: [PATCH] ASoC: simple-card: fix simple card widgets routing property name usage
Date: Fri, 10 Jan 2014 13:17:27 +0800
Message-ID: <1389331047-21437-1-git-send-email-Li.Xiubo@freescale.com>
X-Mailer: git-send-email 1.8.0
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: freescale.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
X-FOPE-CONNECTOR: Id%0$Dn%FREESCALE.MAIL.ONMICROSOFT.COM$RO%1$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix the usage of simple card widgets routing property, and make it the
same with simple card routing property name.

Signed-off-by: Xiubo Li <Li.Xiubo@freescale.com>
---
 Documentation/devicetree/bindings/sound/simple-card.txt | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Documentation/devicetree/bindings/sound/simple-card.txt b/Documentation/devicetree/bindings/sound/simple-card.txt
index e9e20ec..19c84df 100644
--- a/Documentation/devicetree/bindings/sound/simple-card.txt
+++ b/Documentation/devicetree/bindings/sound/simple-card.txt
@@ -43,7 +43,7 @@ Example:
 sound {
 	compatible = "simple-audio-card";
 	simple-audio-card,format = "left_j";
-	simple-audio-routing =
+	simple-audio-card,routing =
 		"MIC_IN", "Mic Jack",
 		"Headphone Jack", "HP_OUT",
 		"Ext Spk", "LINE_OUT";
-- 
1.8.4


