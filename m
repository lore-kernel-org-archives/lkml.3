Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752073AbaJOTD2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Oct 2014 15:03:28 -0400
Received: from mailrelay011.isp.belgacom.be ([195.238.6.178]:40646 "EHLO
	mailrelay011.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751608AbaJOTDY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Oct 2014 15:03:24 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Aq4SAHfEPlRbtBXi/2dsb2JhbABbgw6BK7guBQFzmiMEAoEYFwF9hF8jgRo3iEIBuV6PRoYiiUhkHYQ1BZ1UlhqBRwGCMTsvgQaBRAEBAQ
From: Fabian Frederick <fabf@skynet.be>
To: linux-kernel@vger.kernel.org
Cc: Fabian Frederick <fabf@skynet.be>, Pravin Shelar <pshelar@nicira.com>,
        "David S. Miller" <davem@davemloft.net>, dev@openvswitch.org,
        netdev@vger.kernel.org
Subject: [PATCH 1/1 net-next] openvswitch: kerneldoc warning fix
Date: Wed, 15 Oct 2014 21:03:18 +0200
Message-Id: <1413399798-8514-1-git-send-email-fabf@skynet.be>
X-Mailer: git-send-email 1.9.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

s/sock/gs

Signed-off-by: Fabian Frederick <fabf@skynet.be>
---
 net/openvswitch/vport-geneve.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/openvswitch/vport-geneve.c b/net/openvswitch/vport-geneve.c
index 910b3ef..106a9d8 100644
--- a/net/openvswitch/vport-geneve.c
+++ b/net/openvswitch/vport-geneve.c
@@ -30,7 +30,7 @@
 
 /**
  * struct geneve_port - Keeps track of open UDP ports
- * @sock: The socket created for this port number.
+ * @gs: The socket created for this port number.
  * @name: vport name.
  */
 struct geneve_port {
-- 
1.9.3

