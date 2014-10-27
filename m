Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752576AbaJ0SNo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2014 14:13:44 -0400
Received: from mailrelay006.isp.belgacom.be ([195.238.6.172]:59449 "EHLO
	mailrelay006.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751812AbaJ0SJf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2014 14:09:35 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ArcUAAiKTlRXQ3zJ/2dsb2JhbABcgw6BLLlDCwUBdJo9BAKBHhcBfYQwLyOBGjeIRQG8a48IhjSJcGQdhDUFnWGMaolEgUcBgjE8L4EGgUUBAQE
From: Fabian Frederick <fabf@skynet.be>
To: linux-kernel@vger.kernel.org
Cc: Fabian Frederick <fabf@skynet.be>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Subject: [PATCH 1/1 net-next] ipx: replace __inline__ by inline
Date: Mon, 27 Oct 2014 19:09:12 +0100
Message-Id: <1414433352-29210-1-git-send-email-fabf@skynet.be>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Fabian Frederick <fabf@skynet.be>
---
 net/ipx/af_ipx.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/ipx/af_ipx.c b/net/ipx/af_ipx.c
index 91729b8..61ffe3c 100644
--- a/net/ipx/af_ipx.c
+++ b/net/ipx/af_ipx.c
@@ -306,7 +306,7 @@ void ipxitf_down(struct ipx_interface *intrfc)
 	spin_unlock_bh(&ipx_interfaces_lock);
 }
 
-static __inline__ void __ipxitf_put(struct ipx_interface *intrfc)
+static inline void __ipxitf_put(struct ipx_interface *intrfc)
 {
 	if (atomic_dec_and_test(&intrfc->refcnt))
 		__ipxitf_down(intrfc);
-- 
1.9.1

