Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754178Ab3G2Dfp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Jul 2013 23:35:45 -0400
Received: from ch1ehsobe002.messaging.microsoft.com ([216.32.181.182]:55583
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752159Ab3G2Dfn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Jul 2013 23:35:43 -0400
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: 3
X-BigFish: VS3(zzzz1f42h208ch1ee6h1de0h1fdah2073h1202h1e76h1d1ah1d2ah1fc6h1082kzz1de098h8275bh1de097hz2dh2a8h668h839hd24he5bhf0ah1288h12a5h12a9h12bdh12e5h137ah139eh13b6h1441h1504h1537h162dh1631h1758h1898h18e1h1946h19b5h1ad9h1b0ah1d0ch1d2eh1d3fh1dc1h1dfeh1dffh1e23h1155h)
From: Robin Gong <b38343@freescale.com>
To: <lgirdwood@gmail.com>, <broonie@kernel.org>
CC: <linux-kernel@vger.kernel.org>, <rdunlap@infradead.org>
Subject: [PATCH] regulator:pfuze100: add MODULE_LICENSE() in pfuze100 driver
Date: Mon, 29 Jul 2013 11:40:11 +0800
Message-ID: <1375069211-32069-1-git-send-email-b38343@freescale.com>
X-Mailer: git-send-email 1.7.5.4
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: freescale.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix building error on x86_64 and i386:
WARNING: modpost: missing MODULE_LICENSE() in
drivers/regulator/pfuze100-regulator.o

Signed-off-by: Robin Gong <b38343@freescale.com>
---
 drivers/regulator/pfuze100-regulator.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/regulator/pfuze100-regulator.c b/drivers/regulator/pfuze100-regulator.c
index e2f9dcf..2dadc31 100644
--- a/drivers/regulator/pfuze100-regulator.c
+++ b/drivers/regulator/pfuze100-regulator.c
@@ -451,4 +451,5 @@ module_i2c_driver(pfuze_driver);
 
 MODULE_AUTHOR("Robin Gong <b38343@freescale.com>");
 MODULE_DESCRIPTION("Regulator Driver for Freescale PFUZE100 PMIC");
+MODULE_LICENSE("GPL v2");
 MODULE_ALIAS("pfuze100-regulator");
-- 
1.7.5.4


