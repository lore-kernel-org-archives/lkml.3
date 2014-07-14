Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756560AbaGNQb6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2014 12:31:58 -0400
Received: from mailrelay006.isp.belgacom.be ([195.238.6.172]:64565 "EHLO
	mailrelay006.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756526AbaGNQbn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2014 12:31:43 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AtgNACUFxFNXQxRI/2dsb2JhbABZgw6tSQEBAQEBAQUBbpt/AYEVF3WEBAEFViMQUTkeGYhGAcgxF4V7iGxkBxaELQWbDpQeg0Y7gTE
From: Fabian Frederick <fabf@skynet.be>
To: linux-kernel@vger.kernel.org
Cc: davem@davemloft.net, joe@perches.com, Fabian Frederick <fabf@skynet.be>,
        Jon Maloy <jon.maloy@ericsson.com>,
        Allan Stephens <allan.stephens@windriver.com>, netdev@vger.kernel.org,
        tipc-discussion@lists.sourceforge.net
Subject: [PATCH 02/16] tipc: remove unnecessary break after return
Date: Mon, 14 Jul 2014 18:30:52 +0200
Message-Id: <1405355467-7350-3-git-send-email-fabf@skynet.be>
X-Mailer: git-send-email 1.8.4.5
In-Reply-To: <1405355467-7350-1-git-send-email-fabf@skynet.be>
References: <1405355467-7350-1-git-send-email-fabf@skynet.be>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Fabian Frederick <fabf@skynet.be>
---
 net/tipc/socket.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/net/tipc/socket.c b/net/tipc/socket.c
index ef04755..857f1dfb 100644
--- a/net/tipc/socket.c
+++ b/net/tipc/socket.c
@@ -1952,7 +1952,6 @@ int tipc_ioctl(struct socket *sk, unsigned int cmd, unsigned long arg)
 			return 0;
 		}
 		return -EADDRNOTAVAIL;
-		break;
 	default:
 		return -ENOIOCTLCMD;
 	}
-- 
1.8.4.5

