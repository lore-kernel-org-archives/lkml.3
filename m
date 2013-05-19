Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753061Ab3ESNsp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 May 2013 09:48:45 -0400
Received: from mail-bk0-f50.google.com ([209.85.214.50]:56967 "EHLO
	mail-bk0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751699Ab3ESNsn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 May 2013 09:48:43 -0400
From: Boian Bonev <bbonev@ipacct.com>
To: linux-kernel@vger.kernel.org
Cc: "David S. Miller" <davem@davemloft.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        James Morris <jmorris@namei.org>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Patrick McHardy <kaber@trash.net>, Boian Bonev <bbonev@ipacct.com>
Subject: [PATCH 1/1] net: Fix a typo in comment in ip_tunnels.h
Date: Sun, 19 May 2013 16:48:20 +0300
Message-Id: <1368971300-14442-1-git-send-email-bbonev@ipacct.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Trivial typo fix

Signed-off-by: Boian Bonev <bbonev@ipacct.com>
---
I am new around and decided to start with something simple to test the process.

The fix applies both to net and net-next.

 include/net/ip_tunnels.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/net/ip_tunnels.h b/include/net/ip_tunnels.h
index 4b6f0b2..2b19fb6 100644
--- a/include/net/ip_tunnels.h
+++ b/include/net/ip_tunnels.h
@@ -132,7 +132,7 @@ static inline u8 ip_tunnel_get_dsfield(const struct iphdr *iph,
 		return 0;
 }
 
-/* Propogate ECN bits out */
+/* Propagate ECN bits out */
 static inline u8 ip_tunnel_ecn_encap(u8 tos, const struct iphdr *iph,
 				     const struct sk_buff *skb)
 {
-- 
1.7.9.5

