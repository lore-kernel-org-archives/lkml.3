Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757824AbaGBUXp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jul 2014 16:23:45 -0400
Received: from mailrelay006.isp.belgacom.be ([195.238.6.172]:20698 "EHLO
	mailrelay006.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754511AbaGBUXo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jul 2014 16:23:44 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Am4IAMJptFNXQBPR/2dsb2JhbABagw2sagUBAQEBAQEFAW4BmWeBBxd1hGAjgRo3iEYBx2AXhXCITmQdhC0Fmm2UCoNFO4Ex
From: Fabian Frederick <fabf@skynet.be>
To: linux-kernel@vger.kernel.org
Cc: Fabian Frederick <fabf@skynet.be>, "David S. Miller" <davem@davemloft.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>, netdev@vger.kernel.org
Subject: [PATCH 1/1] ipconfig: add static to local variable
Date: Wed,  2 Jul 2014 22:22:20 +0200
Message-Id: <1404332540-5249-1-git-send-email-fabf@skynet.be>
X-Mailer: git-send-email 1.8.4.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ic_dev_xid is only used in ipconfig.c

Cc: "David S. Miller" <davem@davemloft.net>
Cc: Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>
Cc: netdev@vger.kernel.org
Signed-off-by: Fabian Frederick <fabf@skynet.be>
---
 net/ipv4/ipconfig.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/ipv4/ipconfig.c b/net/ipv4/ipconfig.c
index b3e86ea..f0f3f9f 100644
--- a/net/ipv4/ipconfig.c
+++ b/net/ipv4/ipconfig.c
@@ -143,7 +143,7 @@ __be32 ic_servaddr = NONE;	/* Boot server IP address */
 __be32 root_server_addr = NONE;	/* Address of NFS server */
 u8 root_server_path[256] = { 0, };	/* Path to mount as root */
 
-__be32 ic_dev_xid;		/* Device under configuration */
+static __be32 ic_dev_xid;		/* Device under configuration */
 
 /* vendor class identifier */
 static char vendor_class_identifier[253] __initdata;
-- 
1.8.4.5

