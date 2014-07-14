Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756607AbaGNQcT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2014 12:32:19 -0400
Received: from mailrelay006.isp.belgacom.be ([195.238.6.172]:27168 "EHLO
	mailrelay006.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756587AbaGNQcI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2014 12:32:08 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AtgNACUFxFNXQxRI/2dsb2JhbABZgw6tSQEBAQEBAQUBbpt/AYEVF3WEBAEFViMQUTkeGYhGAcgxF4V7iGxkBxaELQWbDpQeg0Y7gTE
From: Fabian Frederick <fabf@skynet.be>
To: linux-kernel@vger.kernel.org
Cc: davem@davemloft.net, joe@perches.com, Fabian Frederick <fabf@skynet.be>,
        netdev@vger.kernel.org
Subject: [PATCH 06/16] pktgen: remove unnecessary break after goto
Date: Mon, 14 Jul 2014 18:30:56 +0200
Message-Id: <1405355467-7350-7-git-send-email-fabf@skynet.be>
X-Mailer: git-send-email 1.8.4.5
In-Reply-To: <1405355467-7350-1-git-send-email-fabf@skynet.be>
References: <1405355467-7350-1-git-send-email-fabf@skynet.be>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Fabian Frederick <fabf@skynet.be>
---
 net/core/pktgen.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/net/core/pktgen.c b/net/core/pktgen.c
index fc17a9d..8d77f04 100644
--- a/net/core/pktgen.c
+++ b/net/core/pktgen.c
@@ -802,7 +802,6 @@ static int strn_len(const char __user * user_buffer, unsigned int maxlen)
 		case '\t':
 		case ' ':
 			goto done_str;
-			break;
 		default:
 			break;
 		}
-- 
1.8.4.5

