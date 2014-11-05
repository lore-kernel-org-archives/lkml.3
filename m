Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751322AbaKEXmP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2014 18:42:15 -0500
Received: from smtprelay0220.hostedemail.com ([216.40.44.220]:53014 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750796AbaKEXmN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2014 18:42:13 -0500
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::,RULES_HIT:41:355:379:541:800:960:973:988:989:1260:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1539:1593:1594:1711:1714:1730:1747:1777:1792:2393:2559:2562:2828:3138:3139:3140:3141:3142:3350:3865:3872:4321:5007:6261:9592:10004:10400:10848:11026:11232:11658:11914:12517:12519:12555:13069:13311:13357:14394:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: able32_875d8252c7738
X-Filterd-Recvd-Size: 1504
Message-ID: <1415230929.6634.38.camel@perches.com>
Subject: [PATCH net-next] sock.h: Remove unused NETDEBUG macro
From: Joe Perches <joe@perches.com>
To: "David S. Miller" <davem@davemloft.net>
Cc: netdev <netdev@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>
Date: Wed, 05 Nov 2014 15:42:09 -0800
In-Reply-To: <1415230568.6634.36.camel@perches.com>
References: <1415230568.6634.36.camel@perches.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.12.7-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It's unused now, just delete it.

Signed-off-by: Joe Perches <joe@perches.com>
---

Assuming the 2 NETDEBUG conversion deletion patches are applied...

 include/net/sock.h | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/include/net/sock.h b/include/net/sock.h
index 7db3db1..6767d75 100644
--- a/include/net/sock.h
+++ b/include/net/sock.h
@@ -2280,9 +2280,6 @@ bool sk_net_capable(const struct sock *sk, int cap);
  *	Enable debug/info messages
  */
 extern int net_msg_warn;
-#define NETDEBUG(fmt, args...) \
-	do { if (net_msg_warn) printk(fmt,##args); } while (0)
-
 #define LIMIT_NETDEBUG(fmt, args...) \
 	do { if (net_msg_warn && net_ratelimit()) printk(fmt,##args); } while(0)
 


