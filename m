Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757244Ab3IAWpb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Sep 2013 18:45:31 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:49331 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755700Ab3IAWpJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Sep 2013 18:45:09 -0400
Message-ID: <1378075508.1953.27.camel@joe-AO722>
Subject: [PATCH] batman: Remove reference to compare_ether_addr
From: Joe Perches <joe@perches.com>
To: Marek Lindner <lindner_marek@yahoo.de>,
        Simon Wunderlich <siwu@hrz.tu-chemnitz.de>,
        Antonio Quartulli <ordex@autistici.org>
Cc: "David S. Miller" <davem@davemloft.net>, b.a.t.m.a.n@lists.open-mesh.org,
        netdev@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Date: Sun, 01 Sep 2013 15:45:08 -0700
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This function is being removed, rename the reference.

Signed-off-by: Joe Perches <joe@perches.com>
---
 net/batman-adv/main.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/batman-adv/main.h b/net/batman-adv/main.h
index 5e9aebb..7333cf8 100644
--- a/net/batman-adv/main.h
+++ b/net/batman-adv/main.h
@@ -253,7 +253,7 @@ static inline void batadv_dbg(int type __always_unused,
 
 /* returns 1 if they are the same ethernet addr
  *
- * note: can't use compare_ether_addr() as it requires aligned memory
+ * note: can't use ether_addr_equal() as it requires aligned memory
  */
 static inline int batadv_compare_eth(const void *data1, const void *data2)
 {


