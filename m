Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755386Ab3J1GEw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Oct 2013 02:04:52 -0400
Received: from e32.co.us.ibm.com ([32.97.110.150]:42985 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752443Ab3J1GEr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Oct 2013 02:04:47 -0400
From: Zhi Yong Wu <zwu.kernel@gmail.com>
To: netdev@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, stephen@networkplumber.org,
        davem@davemloft.net, Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>
Subject: [PATCH v2 2/3] net, datagram: fix the incorrect comment in zerocopy_sg_from_iovec()
Date: Mon, 28 Oct 2013 14:01:49 +0800
Message-Id: <1382940110-10737-2-git-send-email-zwu.kernel@gmail.com>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1382940110-10737-1-git-send-email-zwu.kernel@gmail.com>
References: <1382940110-10737-1-git-send-email-zwu.kernel@gmail.com>
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13102806-0928-0000-0000-000002F2A303
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>

Signed-off-by: Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>
---
 net/core/datagram.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/core/datagram.c b/net/core/datagram.c
index af814e7..a16ed7b 100644
--- a/net/core/datagram.c
+++ b/net/core/datagram.c
@@ -577,7 +577,7 @@ EXPORT_SYMBOL(skb_copy_datagram_from_iovec);
 /**
  *	zerocopy_sg_from_iovec - Build a zerocopy datagram from an iovec
  *	@skb: buffer to copy
- *	@from: io vector to copy to
+ *	@from: io vector to copy from
  *	@offset: offset in the io vector to start copying from
  *	@count: amount of vectors to copy to buffer from
  *
-- 
1.7.11.7

