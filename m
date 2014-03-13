Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753319AbaCMHnl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Mar 2014 03:43:41 -0400
Received: from [65.55.88.15] ([65.55.88.15]:31247 "EHLO
	tx2outboundpool.messaging.microsoft.com" rhost-flags-FAIL-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1753219AbaCMHnh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Mar 2014 03:43:37 -0400
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: 0
X-BigFish: VS0(zze0eahzz1f42h2148h208ch1ee6h1de0h1fdah2073h2146h1202h1e76h2189h1d1ah1d2ah21bch1fc6hzz1de098h8275bh1de097hz2dh2a8h839hd24he5bhf0ah1288h12a5h12a9h12bdh12e5h137ah139eh13b6h1441h1504h1537h162dh1631h1758h1898h18e1h1946h19b5h1ad9h1b0ah1b2fh2222h224fh1fb3h1d0ch1d2eh1d3fh1dc1h1de2h1dfeh1dffh1e23h1fe8h1ff5h2218h2216h226dh22d0h24afh2327h2336h2438h2461h2487h24d7h2516h2545h255eh25cch25f6h2605h1155h)
From: Suresh Gupta <suresh.gupta@freescale.com>
To: <balbi@ti.com>, <gregkh@linuxfoundation.org>
CC: <linux-usb@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <suresh.gupta@freescale.com>
Subject: [PATCH] USB : Gadget: fsl: add information message
Date: Thu, 13 Mar 2014 18:41:50 +0530
Message-ID: <1394716310-27001-1-git-send-email-suresh.gupta@freescale.com>
X-Mailer: git-send-email 1.8.4.1
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: freescale.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
X-FOPE-CONNECTOR: Id%0$Dn%FREESCALE.MAIL.ONMICROSOFT.COM$RO%1$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

	Message helps to understand that the Freescale Gadget driver
	is up without any error.

Signed-off-by: Suresh Gupta <suresh.gupta@freescale.com>
---
 drivers/usb/gadget/fsl_udc_core.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/usb/gadget/fsl_udc_core.c b/drivers/usb/gadget/fsl_udc_core.c
index 9a93727..455d0ab 100644
--- a/drivers/usb/gadget/fsl_udc_core.c
+++ b/drivers/usb/gadget/fsl_udc_core.c
@@ -2503,6 +2503,7 @@ static int __init fsl_udc_probe(struct platform_device *pdev)
 		goto err_del_udc;
 
 	create_proc_file();
+	pr_info("%s (%s)\n", driver_desc, DRIVER_VERSION);
 	return 0;
 
 err_del_udc:
-- 
1.8.4.1


