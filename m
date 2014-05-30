Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933901AbaE3Pv7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 May 2014 11:51:59 -0400
Received: from mail-pb0-f52.google.com ([209.85.160.52]:44816 "EHLO
	mail-pb0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965151AbaE3PqV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 May 2014 11:46:21 -0400
Date: Fri, 30 May 2014 21:16:05 +0530
From: Himangi Saraogi <himangi774@gmail.com>
To: Chien Yen <chien.yen@oracle.com>, "David S. Miller" <davem@davemloft.net>,
        rds-devel@oss.oracle.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: julia.lawall@lip6.fr
Subject: [PATCH] RDS/RDMA: Replace comma with semicolon
Message-ID: <20140530154605.GA4049@himangi-Dell>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch replaces a comma between expression statements by a semicolon.

A simplified version of the semantic patch that performs this
transformation is as follows:

// <smpl>
@r@
expression e1,e2,e;
type T;
identifier i;
@@

 e1
-,
+;
 e2;
// </smpl>


Signed-off-by: Himangi Saraogi <himangi774@gmail.com>
Acked-by: Julia Lawall <julia.lawall@lip6.fr>
---
To send to: Chien Yen <chien.yen@oracle.com>,"David S. Miller" <davem@davemloft.net>,rds-devel@oss.oracle.com,netdev@vger.kernel.org,linux-kernel@vger.kernel.org

 net/rds/rdma_transport.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/rds/rdma_transport.c b/net/rds/rdma_transport.c
index c2be901..6cd9d1d 100644
--- a/net/rds/rdma_transport.c
+++ b/net/rds/rdma_transport.c
@@ -168,7 +168,7 @@ static int rds_rdma_listen_init(void)
 		return ret;
 	}
 
-	sin.sin_family = AF_INET,
+	sin.sin_family = AF_INET;
 	sin.sin_addr.s_addr = (__force u32)htonl(INADDR_ANY);
 	sin.sin_port = (__force u16)htons(RDS_PORT);
 
-- 
1.9.1

