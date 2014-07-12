Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753151AbaGLSLq (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Jul 2014 14:11:46 -0400
Received: from mailrelay009.isp.belgacom.be ([195.238.6.176]:30174 "EHLO
	mailrelay009.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753031AbaGLSLm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Jul 2014 14:11:42 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AuMJAJB5wVNXQ56W/2dsb2JhbABZgw6tMgEBAQEBAQUBbpt/AYEQF3WEBAEFJy8jEFE5HhmIRgG1CJINF4V7iGxkBxaELQWbDotXiEaDRjuBMQ
From: Fabian Frederick <fabf@skynet.be>
To: linux-kernel@vger.kernel.org
Cc: davem@davemloft.net, joe@perches.com, Fabian Frederick <fabf@skynet.be>,
        "John W. Linville" <linville@tuxdriver.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH V2 6/9] orinoco_usb: remove unnecessary break after goto
Date: Sat, 12 Jul 2014 20:09:45 +0200
Message-Id: <1405188597-2815-7-git-send-email-fabf@skynet.be>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1405188597-2815-1-git-send-email-fabf@skynet.be>
References: <1405188597-2815-1-git-send-email-fabf@skynet.be>
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
1.9.1

