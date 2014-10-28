Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757028AbaJ1LUR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2014 07:20:17 -0400
Received: from mail.karo-electronics.de ([81.173.242.67]:64427 "EHLO
	mail.karo-electronics.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754699AbaJ1LCE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2014 07:02:04 -0400
From: =?UTF-8?q?Lothar=20Wa=C3=9Fmann?= <LW@KARO-electronics.de>
To: netdev@vger.kernel.org
Cc: "David S. Miller" <davem@davemloft.net>,
        Russell King <rmk+kernel@arm.linux.org.uk>,
        Frank Li <Frank.Li@freescale.com>,
        Fabio Estevam <fabio.estevam@freescale.com>,
        linux-kernel@vger.kernel.org,
        =?UTF-8?q?Lothar=20Wa=C3=9Fmann?= <LW@KARO-electronics.de>,
        <linux-arm-kernel@lists.infradead.org>
Subject: [PATCHv2 1/6] net: fec: indentation cleanup; no functional change
Date: Tue, 28 Oct 2014 12:01:39 +0100
Message-Id: <1414494104-27943-2-git-send-email-LW@KARO-electronics.de>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1414494104-27943-1-git-send-email-LW@KARO-electronics.de>
References: <1414494104-27943-1-git-send-email-LW@KARO-electronics.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Lothar Waßmann <LW@KARO-electronics.de>
---
 drivers/net/ethernet/freescale/fec_main.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/freescale/fec_main.c b/drivers/net/ethernet/freescale/fec_main.c
index e364d1f..decea57 100644
--- a/drivers/net/ethernet/freescale/fec_main.c
+++ b/drivers/net/ethernet/freescale/fec_main.c
@@ -101,7 +101,7 @@ static void fec_enet_itr_coal_init(struct net_device *ndev);
  * frames not being transmitted until there is a 0-to-1 transition on
  * ENET_TDAR[TDAR].
  */
-#define FEC_QUIRK_ERR006358            (1 << 7)
+#define FEC_QUIRK_ERR006358		(1 << 7)
 /* ENET IP hw AVB
  *
  * i.MX6SX ENET IP add Audio Video Bridging (AVB) feature support.
-- 
1.7.10.4

