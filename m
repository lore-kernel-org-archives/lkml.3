Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752474AbaKDWLc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2014 17:11:32 -0500
Received: from mailrelay001.isp.belgacom.be ([195.238.6.51]:16562 "EHLO
	mailrelay001.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751129AbaKDWLb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2014 17:11:31 -0500
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Ar8SAMJOWVRbsl9p/2dsb2JhbABagw6BLbsKBQF0misEAoElFwEBAQEBfYQwLyOBGjeIRQG5KI8LLIY3iXVkHYQ1BZ4OllKBRwGCMTwvgQaBRQEBAQ
From: Fabian Frederick <fabf@skynet.be>
To: linux-kernel@vger.kernel.org
Cc: Joe Perches <joe@perches.com>, Fabian Frederick <fabf@skynet.be>,
        "David S. Miller" <davem@davemloft.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        James Morris <jmorris@namei.org>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Patrick McHardy <kaber@trash.net>, Jiri Kosina <trivial@kernel.org>,
        netdev@vger.kernel.org
Subject: [PATCH/TRIVIAL 1/1 net-next] udp: remove blank line between set and test
Date: Tue,  4 Nov 2014 23:11:19 +0100
Message-Id: <1415139079-7931-1-git-send-email-fabf@skynet.be>
X-Mailer: git-send-email 1.9.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Suggested-by: Joe Perches <joe@perches.com>
Signed-off-by: Fabian Frederick <fabf@skynet.be>
---
 net/ipv4/udp.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/net/ipv4/udp.c b/net/ipv4/udp.c
index cf0cece..3f001db 100644
--- a/net/ipv4/udp.c
+++ b/net/ipv4/udp.c
@@ -1784,7 +1784,6 @@ int __udp4_lib_rcv(struct sk_buff *skb, struct udp_table *udptable,
 				saddr, daddr, udptable);
 
 	sk = __udp4_lib_lookup_skb(skb, uh->source, uh->dest, udptable);
-
 	if (sk != NULL) {
 		int ret;
 
-- 
1.9.3

