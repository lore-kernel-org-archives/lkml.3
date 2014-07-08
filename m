Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932413AbaGHTF7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2014 15:05:59 -0400
Received: from mailrelay001.isp.belgacom.be ([195.238.6.51]:61651 "EHLO
	mailrelay001.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932341AbaGHTFz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2014 15:05:55 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApgNAORAvFNXQDwH/2dsb2JhbABZgw6tJQEBAQEBAQUBbgGZWQGBFxd1hAQBBSdSEFE5HhmIRgHIJheFeohkZAcWhC0FmnaLTIhAg0U7gTE
From: Fabian Frederick <fabf@skynet.be>
To: linux-kernel@vger.kernel.org
Cc: davem@davemloft.net, joe@perches.com, Fabian Frederick <fabf@skynet.be>
Subject: [PATCH 6/9] orinoco_usb: remove unnecessary break after goto
Date: Tue,  8 Jul 2014 21:05:26 +0200
Message-Id: <1404846329-19235-7-git-send-email-fabf@skynet.be>
X-Mailer: git-send-email 1.8.4.5
In-Reply-To: <1404846329-19235-1-git-send-email-fabf@skynet.be>
References: <1404846329-19235-1-git-send-email-fabf@skynet.be>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Fabian Frederick <fabf@skynet.be>
---
 drivers/net/wireless/orinoco/orinoco_usb.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/net/wireless/orinoco/orinoco_usb.c b/drivers/net/wireless/orinoco/orinoco_usb.c
index c90939c..d3cf7c3 100644
--- a/drivers/net/wireless/orinoco/orinoco_usb.c
+++ b/drivers/net/wireless/orinoco/orinoco_usb.c
@@ -921,7 +921,6 @@ static int ezusb_access_ltv(struct ezusb_priv *upriv,
 			retval = -EFAULT;
 		}
 		goto exit;
-		break;
 	}
 	if (ctx->in_rid) {
 		struct ezusb_packet *ans = ctx->buf;
-- 
1.8.4.5

