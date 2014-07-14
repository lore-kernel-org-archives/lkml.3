Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932414AbaGNQhd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2014 12:37:33 -0400
Received: from mailrelay008.isp.belgacom.be ([195.238.6.174]:28504 "EHLO
	mailrelay008.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756281AbaGNQfe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2014 12:35:34 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AtgNAIUGxFNXQxRI/2dsb2JhbABZgw6tSQEBAQEBAQUBbpt/AYEVF3WEBAEFViMQUTkeGYhGAcg2F4V7iGxkBxaELQWbDpQeg0Y7gTE
From: Fabian Frederick <fabf@skynet.be>
To: linux-kernel@vger.kernel.org
Cc: davem@davemloft.net, joe@perches.com, Fabian Frederick <fabf@skynet.be>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        James Morris <jmorris@namei.org>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Patrick McHardy <kaber@trash.net>, netdev@vger.kernel.org
Subject: [PATCH 11/16] ipv6: remove unnecessary break after return
Date: Mon, 14 Jul 2014 18:36:34 +0200
Message-Id: <1405355799-7691-2-git-send-email-fabf@skynet.be>
X-Mailer: git-send-email 1.8.4.5
In-Reply-To: <1405355799-7691-1-git-send-email-fabf@skynet.be>
References: <1405355799-7691-1-git-send-email-fabf@skynet.be>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Fabian Frederick <fabf@skynet.be>
---
 net/ipv6/ipv6_sockglue.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/net/ipv6/ipv6_sockglue.c b/net/ipv6/ipv6_sockglue.c
index edb58af..7666cfe 100644
--- a/net/ipv6/ipv6_sockglue.c
+++ b/net/ipv6/ipv6_sockglue.c
@@ -1158,7 +1158,6 @@ static int do_ipv6_getsockopt(struct sock *sk, int level, int optname,
 			return -EFAULT;
 
 		return 0;
-		break;
 	}
 
 	case IPV6_TRANSPARENT:
-- 
1.8.4.5

