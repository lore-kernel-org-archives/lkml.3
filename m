Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752568AbaKDTZo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2014 14:25:44 -0500
Received: from mailrelay009.isp.belgacom.be ([195.238.6.176]:19261 "EHLO
	mailrelay009.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751687AbaKDTZm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2014 14:25:42 -0500
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Au4SACgnWVRbsl9p/2dsb2JhbABbgw6BLLp9BgEBAQEBBQF0miIEAoEkFwEBAQEBfYRfI4EaN4hFAb5rjzWGN4l1ZB2ENQWeB5ZPgUcBgjE8L4EGgUUBAQE
From: Fabian Frederick <fabf@skynet.be>
To: linux-kernel@vger.kernel.org
Cc: Fabian Frederick <fabf@skynet.be>, "David S. Miller" <davem@davemloft.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        James Morris <jmorris@namei.org>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Patrick McHardy <kaber@trash.net>, netdev@vger.kernel.org
Subject: [PATCH 1/1 net-next] tcp: spelling s/plugable/pluggable
Date: Tue,  4 Nov 2014 20:25:38 +0100
Message-Id: <1415129138-11901-1-git-send-email-fabf@skynet.be>
X-Mailer: git-send-email 1.9.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Fabian Frederick <fabf@skynet.be>
---
 net/ipv4/tcp_cong.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/ipv4/tcp_cong.c b/net/ipv4/tcp_cong.c
index b1c5970..27ead0d 100644
--- a/net/ipv4/tcp_cong.c
+++ b/net/ipv4/tcp_cong.c
@@ -1,5 +1,5 @@
 /*
- * Plugable TCP congestion control support and newReno
+ * Pluggable TCP congestion control support and newReno
  * congestion control.
  * Based on ideas from I/O scheduler support and Web100.
  *
-- 
1.9.3

