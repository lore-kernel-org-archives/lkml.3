Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757915Ab3GWRSD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jul 2013 13:18:03 -0400
Received: from co1ehsobe005.messaging.microsoft.com ([216.32.180.188]:53893
	"EHLO co1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757667Ab3GWRSB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jul 2013 13:18:01 -0400
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: 0
X-BigFish: VS0(zzzz1f42h208ch1ee6h1de0h1fdah2073h1202h1e76h1d1ah1d2ah1fc6hzz1de098h1de097h8275bhz2dh2a8h668h839hd24he5bhf0ah1288h12a5h12a9h12bdh12e5h137ah139eh13b6h1441h1504h1537h162dh1631h1758h1898h18e1h1946h19b5h1ad9h1b0ah1d0ch1d2eh1d3fh1dc1h1dfeh1dffh1e23h1155h)
From: Fabio Estevam <fabio.estevam@freescale.com>
To: <gregkh@linuxfoundation.org>
CC: <kernel@pengutronix.de>, <linux-kernel@vger.kernel.org>,
        Fabio Estevam <fabio.estevam@freescale.com>
Subject: [PATCH] imx-drm: TODO: Remove LVDS support from missing features list.
Date: Tue, 23 Jul 2013 14:15:32 -0300
Message-ID: <1374599732-24255-1-git-send-email-fabio.estevam@freescale.com>
X-Mailer: git-send-email 1.8.1.2
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: freescale.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

LVDS Display Bridge is currently supported, so remove it from the missing
features list.

Signed-off-by: Fabio Estevam <fabio.estevam@freescale.com>
---
 drivers/staging/imx-drm/TODO | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/staging/imx-drm/TODO b/drivers/staging/imx-drm/TODO
index f806415..9cfa2a7 100644
--- a/drivers/staging/imx-drm/TODO
+++ b/drivers/staging/imx-drm/TODO
@@ -10,7 +10,6 @@ TODO:
 Missing features (not necessarily for moving out of staging):
 
 - Add KMS plane support for CRTC driver
-- Add LDB (LVDS Display Bridge) support
 - Add i.MX6 HDMI support
 - Add support for IC (Image converter)
 - Add support for CSI (CMOS Sensor interface)
-- 
1.8.1.2


