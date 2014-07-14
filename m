Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756692AbaGNQdp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2014 12:33:45 -0400
Received: from mailrelay006.isp.belgacom.be ([195.238.6.172]:27168 "EHLO
	mailrelay006.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756570AbaGNQcE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2014 12:32:04 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AtgNACUFxFNXQxRI/2dsb2JhbABZgw6tSQEBAQEBAQUBbpt/AYEVF3WEBAEFJy8jEFE5HhmIRgHIMReFe4hsZAcWhC0Fmw6UHoNGO4Ex
From: Fabian Frederick <fabf@skynet.be>
To: linux-kernel@vger.kernel.org
Cc: davem@davemloft.net, joe@perches.com, Fabian Frederick <fabf@skynet.be>,
        Paul Moore <paul@paul-moore.com>, netdev@vger.kernel.org
Subject: [PATCH 05/16] netlabel: remove unnecessary break after goto
Date: Mon, 14 Jul 2014 18:30:55 +0200
Message-Id: <1405355467-7350-6-git-send-email-fabf@skynet.be>
X-Mailer: git-send-email 1.8.4.5
In-Reply-To: <1405355467-7350-1-git-send-email-fabf@skynet.be>
References: <1405355467-7350-1-git-send-email-fabf@skynet.be>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Fabian Frederick <fabf@skynet.be>
---
 net/netlabel/netlabel_kapi.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/net/netlabel/netlabel_kapi.c b/net/netlabel/netlabel_kapi.c
index 3045a96..fe9415e 100644
--- a/net/netlabel/netlabel_kapi.c
+++ b/net/netlabel/netlabel_kapi.c
@@ -170,7 +170,6 @@ int netlbl_cfg_unlbl_map_add(const char *domain,
 #endif /* IPv6 */
 		default:
 			goto cfg_unlbl_map_add_failure;
-			break;
 		}
 
 		entry->def.addrsel = addrmap;
-- 
1.8.4.5

