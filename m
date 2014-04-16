Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754507AbaDPFrU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2014 01:47:20 -0400
Received: from ch1ehsobe001.messaging.microsoft.com ([216.32.181.181]:50942
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751845AbaDPFrT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2014 01:47:19 -0400
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: 0
X-BigFish: VS0(zzzz1f42h2148h1ee6h1de0h1fdah2073h2146h1202h1e76h2189h1d1ah1d2ah21bch1fc6h208chzz1de098h8275bh1de097hz2dh2a8h839hd24he5bhf0ah1288h12a5h12a9h12bdh12e5h137ah139eh13b6h1441h1504h1537h162dh1631h1758h1898h18e1h1946h19b5h1ad9h1b0ah1b2fh2222h224fh1fb3h1d0ch1d2eh1d3fh1dc1h1dfeh1dffh1e23h1fe8h1ff5h2218h2216h226dh22d0h24afh2327h2336h2438h2461h2487h24d7h2516h2545h255eh25cch25f6h2605h268bh26d3h1155h)
From: Prabhakar Kushwaha <prabhakar@freescale.com>
To: <linux-kernel@vger.kernel.org>
CC: <scottwood@freescale.com>, Prabhakar Kushwaha <prabhakar@freescale.com>
Subject: [PATCH] driver/memory:Add Kconfig help description for IFC
Date: Wed, 16 Apr 2014 11:17:08 +0530
Message-ID: <1397627228-5976-1-git-send-email-prabhakar@freescale.com>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: freescale.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
X-FOPE-CONNECTOR: Id%0$Dn%FREESCALE.MAIL.ONMICROSOFT.COM$RO%1$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Freescale's Integrated Flash controller(IFC) module is used to handle
devices such as NOR, NAND, FPGA and ASIC.

Update same in Help section of Kconfig for IFC.

Signed-off-by: Prabhakar Kushwaha <prabhakar@freescale.com>
---
 drivers/memory/Kconfig |    4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/memory/Kconfig b/drivers/memory/Kconfig
index c59e9c9..9a59581 100644
--- a/drivers/memory/Kconfig
+++ b/drivers/memory/Kconfig
@@ -64,5 +64,9 @@ config TEGRA30_MC
 config FSL_IFC
 	bool
 	depends on FSL_SOC
+	help
+	  This driver is for the Integrated Flash Controller(IFC) module
+	  available in Freescale SoCs. This controller allows to handle
+	  devices such as NOR, NAND, FPGA and ASIC etc.
 
 endif
-- 
1.7.9.5



