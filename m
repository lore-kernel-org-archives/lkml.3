Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753292AbaGLSMK (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Jul 2014 14:12:10 -0400
Received: from mailrelay009.isp.belgacom.be ([195.238.6.176]:30174 "EHLO
	mailrelay009.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753050AbaGLSLs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Jul 2014 14:11:48 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AuMJAJB5wVNXQ56W/2dsb2JhbABZgw6tMgEBAQEBAQUBbpt/AYEQF3WEBAEFJy8jEFE5HhmIRgG1CJINF4V7iGxkBxaELQWbDpQdg0Y7gTE
From: Fabian Frederick <fabf@skynet.be>
To: linux-kernel@vger.kernel.org
Cc: davem@davemloft.net, joe@perches.com, Fabian Frederick <fabf@skynet.be>,
        netdev@vger.kernel.org
Subject: [PATCH V2 9/9] slip: remove unnecessary break after goto
Date: Sat, 12 Jul 2014 20:09:48 +0200
Message-Id: <1405188597-2815-10-git-send-email-fabf@skynet.be>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1405188597-2815-1-git-send-email-fabf@skynet.be>
References: <1405188597-2815-1-git-send-email-fabf@skynet.be>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Fabian Frederick <fabf@skynet.be>
---
 drivers/net/slip/slhc.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/net/slip/slhc.c b/drivers/net/slip/slhc.c
index 1252d9c..079f7ad 100644
--- a/drivers/net/slip/slhc.c
+++ b/drivers/net/slip/slhc.c
@@ -396,7 +396,6 @@ found:
 		   ntohs(cs->cs_ip.tot_len) == hlen)
 			break;
 		goto uncompressed;
-		break;
 	case SPECIAL_I:
 	case SPECIAL_D:
 		/* actual changes match one of our special case encodings --
-- 
1.9.1

