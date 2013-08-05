Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753269Ab3HEOtg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Aug 2013 10:49:36 -0400
Received: from mail2-relais-roc.national.inria.fr ([192.134.164.83]:26011 "EHLO
	mail2-relais-roc.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754022Ab3HEOrt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Aug 2013 10:47:49 -0400
X-IronPort-AV: E=Sophos;i="4.89,819,1367964000"; 
   d="scan'208";a="28546972"
From: Julia Lawall <Julia.Lawall@lip6.fr>
To: "David S. Miller" <davem@davemloft.net>
Cc: kernel-janitors@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] net/vmw_vsock/af_vsock.c: drop unneeded semicolon
Date: Mon,  5 Aug 2013 16:47:38 +0200
Message-Id: <1375714059-29567-4-git-send-email-Julia.Lawall@lip6.fr>
X-Mailer: git-send-email 1.7.8.6
In-Reply-To: <1375714059-29567-1-git-send-email-Julia.Lawall@lip6.fr>
References: <1375714059-29567-1-git-send-email-Julia.Lawall@lip6.fr>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <Julia.Lawall@lip6.fr>

Drop the semicolon at the end of the list_for_each_entry loop header.

Signed-off-by: Julia Lawall <Julia.Lawall@lip6.fr>

---
Not tested, but I can't imagine how the current code could work, since vsk
should end up pointing to a dummy value.

 net/vmw_vsock/af_vsock.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/vmw_vsock/af_vsock.c b/net/vmw_vsock/af_vsock.c
index 593071d..4d93346 100644
--- a/net/vmw_vsock/af_vsock.c
+++ b/net/vmw_vsock/af_vsock.c
@@ -347,7 +347,7 @@ void vsock_for_each_connected_socket(void (*fn)(struct sock *sk))
 	for (i = 0; i < ARRAY_SIZE(vsock_connected_table); i++) {
 		struct vsock_sock *vsk;
 		list_for_each_entry(vsk, &vsock_connected_table[i],
-				    connected_table);
+				    connected_table)
 			fn(sk_vsock(vsk));
 	}
 

