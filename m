Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753252Ab3IWD6A (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Sep 2013 23:58:00 -0400
Received: from mail-db8lp0189.outbound.messaging.microsoft.com ([213.199.154.189]:38954
	"EHLO db8outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753064Ab3IWD57 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Sep 2013 23:57:59 -0400
X-Forefront-Antispam-Report: CIP:137.71.25.57;KIP:(null);UIP:(null);IPV:NLI;H:nwd2mta2.analog.com;RD:nwd2mail11.analog.com;EFVD:NLI
X-SpamScore: 1
X-BigFish: VS1(zzzz1f42h1ee6h1ce5h1fdah201ch2073h1202h1fd0h1e76h1d1ah1cabh1d2ah1fc6hzz1de098h1de097h8275bhz31h87h2a8h839hd24he5bh1288h12a5h12a9h12bdh12e5h137ah139eh13b6h13eah1441h14ddh1504h1537h15a8h162dh1631h1758h17eeh1898h18e1h1946h19b5h1b0ah1d0ch1d2eh1d3fh1dc1h1dfeh1dffh1e23h1fe8h1ff5h129fi1155h)
X-FB-DOMAIN-IP-MATCH: fail
From: Sonic Zhang <sonic.adi@gmail.com>
To: Linus Walleij <linus.walleij@linaro.org>,
        Grant Likely <grant.likely@linaro.org>,
        Stephen Warren <swarren@wwwdotorg.org>
CC: LKML <linux-kernel@vger.kernel.org>,
        <adi-buildroot-devel@lists.sourceforge.net>,
        Sonic Zhang <sonic.zhang@analog.com>
Subject: [PATCH] pinctrl: pinctrl-adi2-bf60x: remove useless and duplicated GPIO definition for PPI2.
Date: Mon, 23 Sep 2013 12:07:52 +0800
Message-ID: <1379909272-5048-1-git-send-email-sonic.adi@gmail.com>
X-Mailer: git-send-email 1.8.2.3
MIME-Version: 1.0
Content-Type: text/plain
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Sonic Zhang <sonic.zhang@analog.com>

Signed-off-by: Sonic Zhang <sonic.zhang@analog.com>
---
 drivers/pinctrl/pinctrl-adi2-bf60x.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/pinctrl/pinctrl-adi2-bf60x.c b/drivers/pinctrl/pinctrl-adi2-bf60x.c
index e90cb80..bf57aea 100644
--- a/drivers/pinctrl/pinctrl-adi2-bf60x.c
+++ b/drivers/pinctrl/pinctrl-adi2-bf60x.c
@@ -236,8 +236,7 @@ static const unsigned ppi2_8b_pins[] = {
 static const unsigned ppi2_16b_pins[] = {
 	GPIO_PA0, GPIO_PA1, GPIO_PA2, GPIO_PA3, GPIO_PA4, GPIO_PA5, GPIO_PA6,
 	GPIO_PA7, GPIO_PA8, GPIO_PA9, GPIO_PA10, GPIO_PA11, GPIO_PA12,
-	GPIO_PA13, GPIO_PA14, GPIO_PA15,
-	GPIO_PA7, GPIO_PB0, GPIO_PB1, GPIO_PB2, GPIO_PB3,
+	GPIO_PA13, GPIO_PA14, GPIO_PA15, GPIO_PB0, GPIO_PB1, GPIO_PB2,
 };
 
 static const unsigned lp0_pins[] = {
-- 
1.8.2.3


