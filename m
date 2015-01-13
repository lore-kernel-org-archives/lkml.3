Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751721AbbAMVLK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2015 16:11:10 -0500
Received: from prod-mail-xrelay07.akamai.com ([72.246.2.115]:48448 "EHLO
	prod-mail-xrelay07.akamai.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750848AbbAMVLJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2015 16:11:09 -0500
From: Debabrata Banerjee <dbanerje@akamai.com>
To: davem@davemloft.net, netdev@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Debabrata Banerjee <dbanerje@akamai.com>
Subject: [PATCH] tcp: Fix RFC reference in comment
Date: Tue, 13 Jan 2015 16:10:31 -0500
Message-Id: <1421183431-29915-1-git-send-email-dbanerje@akamai.com>
X-Mailer: git-send-email 2.2.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Comment in tcp_cwnd_restart() was referencing the wrong RFC for the algorithm
it's implementing.

Signed-off-by: Debabrata Banerjee <dbanerje@akamai.com>
---
 net/ipv4/tcp_output.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/ipv4/tcp_output.c b/net/ipv4/tcp_output.c
index 65caf8b..0c13f88 100644
--- a/net/ipv4/tcp_output.c
+++ b/net/ipv4/tcp_output.c
@@ -139,7 +139,7 @@ static __u16 tcp_advertise_mss(struct sock *sk)
 	return (__u16)mss;
 }
 
-/* RFC2861. Reset CWND after idle period longer RTO to "restart window".
+/* RFC2581 4.1. Reset CWND after idle period longer RTO to "restart window".
  * This is the first part of cwnd validation mechanism. */
 static void tcp_cwnd_restart(struct sock *sk, const struct dst_entry *dst)
 {
-- 
2.2.1

