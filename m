Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755527AbaGHTGs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2014 15:06:48 -0400
Received: from mailrelay001.isp.belgacom.be ([195.238.6.51]:61651 "EHLO
	mailrelay001.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932356AbaGHTF4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2014 15:05:56 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApgNAORAvFNXQDwH/2dsb2JhbABZgw6tJQEBAQEBAQUBbgGZWQGBFxd1hAQBBSdSEFE5HhmIRgHIJheFeohkZAcWhC0FmnaUDINFO4Ex
From: Fabian Frederick <fabf@skynet.be>
To: linux-kernel@vger.kernel.org
Cc: davem@davemloft.net, joe@perches.com, Fabian Frederick <fabf@skynet.be>
Subject: [PATCH 9/9] slip: remove unnecessary break after goto
Date: Tue,  8 Jul 2014 21:05:29 +0200
Message-Id: <1404846329-19235-10-git-send-email-fabf@skynet.be>
X-Mailer: git-send-email 1.8.4.5
In-Reply-To: <1404846329-19235-1-git-send-email-fabf@skynet.be>
References: <1404846329-19235-1-git-send-email-fabf@skynet.be>
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
1.8.4.5

