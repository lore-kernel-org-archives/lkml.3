Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753208Ab3IWDrL (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Sep 2013 23:47:11 -0400
Received: from co1ehsobe006.messaging.microsoft.com ([216.32.180.189]:46831
	"EHLO co1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753023Ab3IWDrJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Sep 2013 23:47:09 -0400
X-Forefront-Antispam-Report: CIP:137.71.25.57;KIP:(null);UIP:(null);IPV:NLI;H:nwd2mta2.analog.com;RD:nwd2mail11.analog.com;EFVD:NLI
X-SpamScore: 1
X-BigFish: VS1(zzzz1f42h1ee6h1ce5h1fdah201ch2073h1202h1fd0h1e76h1d1ah1cabh1d2ah1fc6hzz1de098h1de097h8275bhz31h87h2a8h839hd24he5bh1288h12a5h12a9h12bdh12e5h137ah139eh13b6h13eah1441h14ddh1504h1537h15a8h162dh1631h1758h17eeh1898h18e1h1946h19b5h1b0ah1d0ch1d2eh1d3fh1dc1h1dfeh1dffh1e23h1fe8h1ff5h129fi1155h)
X-FB-DOMAIN-IP-MATCH: fail
From: Sonic Zhang <sonic.adi@gmail.com>
To: Linus Walleij <linus.walleij@linaro.org>, <dan.carpenter@oracle.com>,
        <sfr@canb.auug.org.au>
CC: LKML <linux-kernel@vger.kernel.org>,
        <adi-buildroot-devel@lists.sourceforge.net>,
        Sonic Zhang <sonic.zhang@analog.com>
Subject: [PATCH] pinctrl: pinctrl-adi2: Add dependency to arch BLACKFIN in Kconfig.
Date: Mon, 23 Sep 2013 11:57:00 +0800
Message-ID: <1379908620-4036-1-git-send-email-sonic.adi@gmail.com>
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
 drivers/pinctrl/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/pinctrl/Kconfig b/drivers/pinctrl/Kconfig
index 08b8337..9bb6efb 100644
--- a/drivers/pinctrl/Kconfig
+++ b/drivers/pinctrl/Kconfig
@@ -51,6 +51,7 @@ config PINCTRL_AB8505
 
 config PINCTRL_ADI2
 	bool "ADI pin controller driver"
+	depends on BLACKFIN
 	select PINMUX
 	select IRQ_DOMAIN
 	help
-- 
1.8.2.3


