Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756321AbaGNQcK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2014 12:32:10 -0400
Received: from mailrelay006.isp.belgacom.be ([195.238.6.172]:27168 "EHLO
	mailrelay006.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756562AbaGNQcA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2014 12:32:00 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AtgNACUFxFNXQxRI/2dsb2JhbABZgw6tSQEBAQEBAQUBbpt/AYEVF3WEBAEFViMQUTkeGYhGAcgxF4V7iGxkBxaELQWbDotXiEeDRjuBMQ
From: Fabian Frederick <fabf@skynet.be>
To: linux-kernel@vger.kernel.org
Cc: davem@davemloft.net, joe@perches.com, Fabian Frederick <fabf@skynet.be>,
        Ursula Braun <ursula.braun@de.ibm.com>, linux390@de.ibm.com,
        linux-s390@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH 04/16] af_iucv: remove unnecessary break after goto
Date: Mon, 14 Jul 2014 18:30:54 +0200
Message-Id: <1405355467-7350-5-git-send-email-fabf@skynet.be>
X-Mailer: git-send-email 1.8.4.5
In-Reply-To: <1405355467-7350-1-git-send-email-fabf@skynet.be>
References: <1405355467-7350-1-git-send-email-fabf@skynet.be>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Fabian Frederick <fabf@skynet.be>
---
 net/iucv/af_iucv.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/net/iucv/af_iucv.c b/net/iucv/af_iucv.c
index 7a95fa4..d79f5fb 100644
--- a/net/iucv/af_iucv.c
+++ b/net/iucv/af_iucv.c
@@ -1103,7 +1103,6 @@ static int iucv_sock_sendmsg(struct kiocb *iocb, struct socket *sock,
 		default:
 			err = -EINVAL;
 			goto out;
-			break;
 		}
 	}
 
-- 
1.8.4.5

